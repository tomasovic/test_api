const express = require("express");
const app = express();
const port = 5000;

app.get("/", (req, res) => {
  res.send("Radiiiii!!!!");
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

// test - trigger build again - ensuring correct build
