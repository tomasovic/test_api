const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello from updated image! Testing ArgoCD Image Updater.");
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

// test
