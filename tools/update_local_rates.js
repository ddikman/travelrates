const fs = require('fs')
const http = require('http');

const apiConfig  = JSON.parse(fs.readFileSync('./assets/data/apiConfiguration.json'))

const url = apiConfig.apiUrl + '?token=' + apiConfig.apiToken;

http.get(url, (res) => {
  const { statusCode } = res;
  if (statusCode != 200) {
    throw new Error(`Got response ${statusCode}`);
  }

  res.setEncoding('utf8');
  let rawData = '';
  res.on('data', (chunk) => { rawData += chunk; });
  res.on('end', () => {
    const filename = './assets/data/rates.json';
    fs.writeFileSync(filename, rawData);
    console.log('updated rates written to ' + filename);
  });
});
