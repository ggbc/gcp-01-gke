const http = require('http');

const orders = [
  { id: 1, product: 'Fuel Tank A', quantity: 100, status: 'pending' },
  { id: 2, product: 'Fuel Tank B', quantity: 200, status: 'delivered' },
];

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');

  if (req.url === '/health') {
    res.writeHead(200);
    res.end(JSON.stringify({ status: 'healthy', service: 'orders-service' }));
    return;
  }

  if (req.url === '/orders') {
    res.writeHead(200);
    res.end(JSON.stringify({ service: 'orders-service', data: orders }));
    return;
  }

  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not found' }));
});

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`orders-service running on port ${PORT}`);
});