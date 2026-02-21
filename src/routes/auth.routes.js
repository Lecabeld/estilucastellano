const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const RefreshToken = require("../models/RefreshToken");
const router = express.Router();

// Registro
router.post("/register", async (req,res)=>{
    const { email, password, role } = req.body;
    try {
        const hashed = await bcrypt.hash(password, 10);
        const user = await User.create({ email, password: hashed, role });
        res.status(201).json({ message:"Usuario creado", userId:user._id });
    } catch(err){
        res.status(400).json({ error: err.message });
    }
});

// Login
router.post("/login", async (req,res)=>{
    const { email, password } = req.body;
    try {
        const user = await User.findOne({ email });
        if(!user) return res.status(404).json({ error:"Usuario no encontrado" });
        const valid = await bcrypt.compare(password, user.password);
        if(!valid) return res.status(401).json({ error:"Contraseña incorrecta" });

        const accessToken = jwt.sign({ userId:user._id, role:user.role }, process.env.JWT_SECRET, { expiresIn:"15m" });
        const refreshToken = jwt.sign({ userId:user._id }, process.env.JWT_REFRESH_SECRET, { expiresIn:"7d" });

        await RefreshToken.create({ token:refreshToken, userId:user._id, expiresAt:new Date(Date.now()+7*24*60*60*1000) });

        res.json({ accessToken, refreshToken });
    } catch(err){
        res.status(500).json({ error: err.message });
    }
});

// Refresh token
router.post("/token", async (req,res)=>{
    const { token } = req.body;
    if(!token) return res.status(401).json({ error:"Token requerido" });

    const stored = await RefreshToken.findOne({ token });
    if(!stored) return res.status(403).json({ error:"Token inválido" });

    jwt.verify(token, process.env.JWT_REFRESH_SECRET, (err,decoded)=>{
        if(err) return res.status(403).json({ error:"Token expirado" });
        const accessToken = jwt.sign({ userId: decoded.userId }, process.env.JWT_SECRET, { expiresIn:"15m" });
        res.json({ accessToken });
    });
});

module.exports = router;
