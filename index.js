const express = require("express");
const app = express();
const port = 5000;

app.get("/", (req, res) => {
  res.send("Jel radi ovo sranje vise????");
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

// test - trigger build again - ensuring correct build
