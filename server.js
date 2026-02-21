require("dotenv").config();
const express = require("express");
const path = require("path");
const mongoose = require("mongoose");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");
const compression = require("compression");
const morgan = require("morgan");
const cors = require("cors");

const authRoutes = require("./src/routes/auth.routes");

const app = express();
app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(compression());
app.use(morgan("combined"));

const limiter = rateLimit({ windowMs: 15*60*1000, max: 100 });
app.use(limiter);

app.use(express.static(path.join(__dirname, "public")));
app.use("/api/auth", authRoutes);

const MONGO_URI = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/estilu";
mongoose.connect(MONGO_URI)
.then(()=>console.log("MongoDB conectado"))
.catch(err=>console.error(err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=>console.log("Servidor corriendo en http://localhost:"+PORT));
