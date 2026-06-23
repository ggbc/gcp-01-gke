const http = require('http');

const inventory = [
  { id: 1, product: 'Fuel Tank A', stock: 500, warehouse: 'RJ-01' },
  { id: 2, product: 'Fuel Tank B', stock: 300, warehouse: 'SP-02' },
];

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');

  if (req.url === '/health') {
    res.writeHead(200);
    res.end(JSON.stringify({ status: 'healthy', service: 'inventory-service' }));
    return;
  }

  if (req.url === '/inventory') {
    res.writeHead(200);
    res.end(JSON.stringify({ service: 'inventory-service', data: inventory }));
    return;
  }

  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not found' }));
});

const PORT = process.env.PORT || 3002;
server.listen(PORT, () => {
  console.log(`inventory-service running on port ${PORT}`);
});