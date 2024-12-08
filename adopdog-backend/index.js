const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json()); // For parsing JSON request bodies

// MongoDB Connection
mongoose
  .connect("mongodb://127.0.0.1:27017/FlutterDB", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("MongoDB connection error:", err));

// Define Dog Schema and Model
const dogSchema = new mongoose.Schema({
  name: { type: String, required: true },
  age: { type: Number, required: true },
  gender: { type: String, required: true },
  color: { type: String },
  weight: { type: Number },
  location: { type: String },
  imageUrl: { type: String },
  description: { type: String },
  owner: {
    name: { type: String },
    bio: { type: String },
    imageUrl: { type: String },
  },
});

const Dog = mongoose.model("Dog", dogSchema);

// Routes

// GET all dogs (Read)
app.get("/dogs", async (req, res) => {
  try {
    const dogs = await Dog.find(); // Fetch all dogs from MongoDB
    res.json(dogs);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch dogs" });
  }
});

// GET a specific dog by ID (Read)
app.get("/dogs/:id", async (req, res) => {
  try {
    const dogId = req.params.id;

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(dogId)) {
      return res.status(400).send({ error: "Invalid ID format" });
    }

    const dog = await Dog.findById(dogId);

    if (!dog) {
      return res.status(404).send({ error: "Dog not found" });
    }

    res.send(dog);
  } catch (err) {
    console.error(err);
    res.status(500).send({ error: "Failed to fetch dog" });
  }
});

// POST a new dog (Create)
app.post("/dogs", async (req, res) => {
  try {
    const newDog = new Dog(req.body); // Create a new dog document
    const savedDog = await newDog.save(); // Save it to MongoDB
    res.status(201).json(savedDog);
  } catch (err) {
    console.error(err);
    res
      .status(400)
      .json({ error: "Failed to create dog", details: err.message });
  }
});

// PUT to update an existing dog by ID (Update)
app.put("/dogs/:id", async (req, res) => {
  try {
    const dogId = req.params.id;

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(dogId)) {
      return res.status(400).send({ error: "Invalid ID format" });
    }

    const updatedDog = await Dog.findByIdAndUpdate(dogId, req.body, {
      new: true, // Return the updated document
      runValidators: true, // Validate the updates
    });

    if (updatedDog) {
      res.json(updatedDog);
    } else {
      res.status(404).json({ error: "Dog not found" });
    }
  } catch (err) {
    console.error(err);
    res
      .status(400)
      .json({ error: "Failed to update dog", details: err.message });
  }
});

// DELETE a dog by ID (Delete)
app.delete("/dogs/:id", async (req, res) => {
  try {
    const dogId = req.params.id;

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(dogId)) {
      return res.status(400).send({ error: "Invalid ID format" });
    }

    const deletedDog = await Dog.findByIdAndDelete(dogId);
    if (deletedDog) {
      res.json(deletedDog);
    } else {
      res.status(404).json({ error: "Dog not found" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to delete dog" });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://192.168.1.15:${PORT}`);
});
