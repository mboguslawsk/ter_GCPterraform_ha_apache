#!/bin/bash

HOSTNAME=$( hostname )
HOSTNAME_MODIFIED=$( echo $HOSTNAME | awk -F'\.' '{print $1}' )


sudo mkdir -p /var/www/html/
touch /var/www/html/index.html

sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Welcome</title>
  <style>
    :root {
      --primary: #4f46e5;
      --secondary: #22c55e;
      --bg: #0f172a;
      --card: #111827;
      --text: #e5e7eb;
      --muted: #9ca3af;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
    }

    body {
      min-height: 100vh;
      background: linear-gradient(135deg, var(--bg), #020617);
      color: var(--text);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }

    .card {
      background: var(--card);
      border-radius: 1rem;
      padding: 2rem 2.5rem;
      max-width: 520px;
      width: 100%;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.45);
      animation: fadeIn 0.8s ease-out;
    }

    h1 {
      font-size: 2rem;
      margin-bottom: 0.75rem;
      color: #fff;
    }

    p {
      color: var(--muted);
      margin-bottom: 1.5rem;
      line-height: 1.6;
    }

    .badge {
      display: inline-block;
      background: rgba(79, 70, 229, 0.15);
      color: var(--primary);
      padding: 0.25rem 0.6rem;
      border-radius: 999px;
      font-size: 0.75rem;
      margin-bottom: 1rem;
    }

    .info {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      margin-bottom: 1.5rem;
    }

    .info div {
      background: #020617;
      border-radius: 0.75rem;
      padding: 0.75rem 1rem;
      font-size: 0.85rem;
    }

    .label {
      display: block;
      color: var(--muted);
      font-size: 0.7rem;
      margin-bottom: 0.25rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    button {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border: none;
      border-radius: 0.75rem;
      padding: 0.75rem 1.25rem;
      color: white;
      font-size: 0.9rem;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      width: 100%;
    }

    button:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(34, 197, 94, 0.25);
    }

    footer {
      margin-top: 1.25rem;
      text-align: center;
      font-size: 0.75rem;
      color: var(--muted);
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  </style>
</head>
<body>
  <div class="card">
    <span class="badge">Server Status</span>
    <h1>Hello from <span id="hostname">${HOSTNAME_MODIFIED}</span></h1>
    <p>
      This page is served dynamically and displays environment-aware
      information with modern styling and a responsive layout.
    </p>

    <div class="info">
      <div>
        <span class="label">Hostname</span>
        <span id="host">${HOSTNAME_MODIFIED}</span>
      </div>
      <div>
        <span class="label">Current Time</span>
        <span id="time">--:--:--</span>
      </div>
    </div>

    <button onclick="refreshTime()">Refresh Time</button>

  </div>

  <script>
    function refreshTime() {
      const now = new Date();
      document.getElementById('time').textContent = now.toLocaleTimeString();
    }

    document.getElementById('year').textContent = new Date().getFullYear();
    refreshTime();
  </script>
</body>
</html>
EOF

sudo systemctl restart apache2