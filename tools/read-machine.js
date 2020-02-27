var fs = require('fs');
var data = fs.readFileSync(0, 'utf-8');

var jsonData = "[" + data.trim().split('\n').join(',') + "]";

var raw = JSON.parse(jsonData);

var tests = raw.filter(item => item.test && item.test.url !== null).map(item => item.test);
tests.forEach(t => {
    t.result = raw.find(r => r.testID === t.id && r.type === 'testDone').result;
    t.prints = raw.filter(r => r.testID === t.id && r.messageType === 'print').map(p => p.message);
    var error = raw.find(r => r.error && r.testID === t.id);
    if (error) {
        t.error = {
            message: error.error,
            trace: error.stackTrace.replace('\\n', '\n')
        }
   }
});

var failures = tests.filter(t => t.result !== 'success');
if (failures.length === 0) {
    console.log('No failures!');
} else {
    console.log(`${failures.length} failures!`);
    failures.forEach(f => {
        console.log(`[${f.result}]: ${f.name}`);
        f.prints.forEach(p => console.log(`${p}`));
        console.log();
        console.log(`error:  ${f.error.message}`);
        console.log(`trace:`);
        console.log(f.error.trace);
    });
    process.exit(1);
}