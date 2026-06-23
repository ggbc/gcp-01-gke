const http = require('http');

function fetchService(host, port, path) {
  return new Promise((resolve, reject) => {
    const options = { hostname: host, port, path, method: 'GET' };
    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(JSON.parse(data)));
    });
    req.on('error', reject);
    req.end();
  });
}

const ORDERS_HOST    = process.env.ORDERS_HOST    || 'orders-service';
const ORDERS_PORT    = process.env.ORDERS_PORT    || 3001;
const INVENTORY_HOST = process.env.INVENTORY_HOST || 'inventory-service';
const INVENTORY_PORT = process.env.INVENTORY_PORT || 3002;

const server = http.createServer(async (req, res) => {
  res.setHeader('Content-Type', 'application/json');

  if (req.url === '/health') {
    res.writeHead(200);
    res.end(JSON.stringify({ status: 'healthy', service: 'api-gateway' }));
    return;
  }

  if (req.url === '/') {
    try {
      const [orders, inventory] = await Promise.all([
        fetchService(ORDERS_HOST, ORDERS_PORT, '/orders'),
        fetchService(INVENTORY_HOST, INVENTORY_PORT, '/inventory'),
      ]);
      res.writeHead(200);
      res.end(JSON.stringify({ orders, inventory }));
    } catch (err) {
      res.writeHead(500);
      res.end(JSON.stringify({ error: err.message }));
    }
    return;
  }

  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not found' }));
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`api-gateway running on port ${PORT}`);
});