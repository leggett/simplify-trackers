#!/usr/bin/env node

const Module = require('module');
const fs = require('fs');

const filename = `${__dirname}/../js/simplify-tracker-blocklist.js`
const contents = fs.readFileSync(filename, {encoding: 'utf8'});

const trackers = function hackExtractTrackersJson() {
  const m = new Module(filename, module);
  m.filename = filename;
  m._compile(`${contents}\nmodule.exports = trackers;`, filename);
  return m.exports;
}();

const copyrightHeader = contents.slice(0, contents.indexOf("\n*/") + "\n*/".length)

const javaOutput = [copyrightHeader];

javaOutput.push("package fyi.simpl.trackers;");
javaOutput.push("import java.util.Arrays;");
javaOutput.push("import java.util.List;");
javaOutput.push("import java.util.function.Predicate;");
javaOutput.push("import java.util.regex.Pattern;");
javaOutput.push("public class TrackingPixels {");
javaOutput.push("  private TrackingPixels() {}");
javaOutput.push("  private static List<String> TRACKER_URLS = Arrays.asList(");

const entries = Object.entries(trackers);

for (let i = 0; i < entries.length; ++i) {
  const [k, v] = entries[i];
  javaOutput.push(`    // ${k}`)
  const patterns = Array.isArray(v) ? v : [v];
  for (let j = 0; j < patterns.length; ++j) {
    let line = `    ${JSON.stringify(patterns[j])}`
    if (i !== entries.length - 1 || j !== patterns.length - 1) {
      line += ",";
    }
    javaOutput.push(line);
  }
}

javaOutput.push("  );");

javaOutput.push(`  private static Predicate<String> TRACKER_URL_PRED = Pattern.compile(`);
javaOutput.push(`    String.join("|", TRACKER_URLS),`);
javaOutput.push(`    Pattern.CASE_INSENSITIVE`);
javaOutput.push(`  ).asPredicate();`);

javaOutput.push(`  public static boolean isEmailTracker(String url) {`);
javaOutput.push(`    return TRACKER_URL_PRED.test(url);`);
javaOutput.push(`  }`);

javaOutput.push("}");

const javaPackageDir = `${__dirname}/fyi/simpl/trackers`
fs.mkdirSync(javaPackageDir, { recursive: true });
fs.writeFileSync(`${javaPackageDir}/TrackingPixels.java`, javaOutput.join("\n"), {encoding: 'utf-8'});
