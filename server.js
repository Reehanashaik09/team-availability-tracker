const express = require('express');
const cors = require('cors');
const app = express();

app.use(express.json());
app.use(cors());
app.use(express.static('public'));

// Seed team records for state management and persistence
let teamMembers = [
  { id: '1', name: 'Alice Johnson', role: 'Frontend Developer', status: 'Available' },
  { id: '2', name: 'Bob Smith', role: 'Backend Engineer', status: 'Busy' },
  { id: '3', name: 'Charlie Davis', role: 'UI/UX Designer', status: 'Away' }
];

// GET: Fetch all team members
app.get('/api/team', (req, res) => {
  res.json(teamMembers);
});

// PATCH: Update team member status
app.patch('/api/team/:id/status', (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  const member = teamMembers.find(m => m.id === id);
  if (!member) {
    return res.status(404).json({ error: 'Team member not found' });
  }

  const validStatuses = ['Available', 'Busy', 'Away'];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ error: 'Invalid status value' });
  }

  member.status = status;
  res.json({ message: 'Status updated successfully', member });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));