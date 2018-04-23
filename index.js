const express = require('express')
var http = require('http');
var https = require('https');
const app = express()
app.my_ip = ""
app.cluster_ip = ""

app.get('/', (req, res) => res.send('Nothing here.'))

app.listen(3000, () => console.log('Listening on port 3000!'))

http.get({'host': 'api.ipify.org', 'port': 80, 'path': '/'}, function(resp) {
      resp.on('data', function(ip) {
              console.log("My public IP address is: " + ip);
              app.my_ip = ip;
      });
});
https.get('https://picolo-b4999.firebaseio.com/cluster_ip.json', (res) => {
      res.on('data', function(ip) {
              console.log("Cluster manager IP address is: " + ip);
              app.cluster_ip = ip;
      });
});

app.post('/start', function(req, res) {
      start(req, res, app.my_ip, app.cluster_ip);
})

app.post('/stop', function(req, res) {
})

function start(req, res, my_ip, cluster_ip) {
    console.log(`command: ./cockroach start --join ${cluster_ip} --insecure --background --advertise-host=${my_ip}`);
}
