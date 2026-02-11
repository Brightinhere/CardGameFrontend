<script setup>
const props = defineProps({
  rooms: Array,
  roomId: String,
  playerName: String,
  players: Array,
  loading: Boolean,
  error: String,
  autoRefresh: Boolean
});

const emit = defineEmits([
  "select-room",
  "update-room-id",
  "update-player-name",
  "toggle-refresh",
  "create-room",
  "join-room",
  "refresh-room",
  "start-game",
  "refresh-rooms"
]);
</script>

<template>
  <section class="card">
    <div class="section-header">
      <h2>Room</h2>
      <div class="refresh-toggle">
        <label>
          <input
            type="checkbox"
            :checked="autoRefresh"
            @change="emit('toggle-refresh', $event.target.checked)"
          />
          Auto refresh
        </label>
      </div>
    </div>

    <div class="rooms-header">
      <h3>Available Rooms</h3>
      <button class="ghost" :disabled="loading" @click="emit('refresh-rooms')">
        Refresh Rooms
      </button>
    </div>

    <div class="rooms-list">
      <p v-if="!rooms?.length" class="muted">No rooms yet. Create one to get started.</p>
      <ul v-else>
        <li v-for="room in rooms" :key="room.id">
          <div class="room-item">
            <div>
              <strong>{{ room.id }}</strong>
              <span class="muted">Players: {{ room.players?.length || 0 }}</span>
            </div>
            <button class="secondary" :disabled="loading" @click="emit('select-room', room.id)">
              Select
            </button>
          </div>
        </li>
      </ul>
    </div>

    <div class="grid">
      <button class="primary" :disabled="loading" @click="emit('create-room')">
        Create Room
      </button>
      <div class="field">
        <label>Room ID</label>
        <input
          type="text"
          placeholder="Paste room id"
          :value="roomId"
          @input="emit('update-room-id', $event.target.value)"
        />
      </div>
    </div>

    <div class="grid">
      <div class="field">
        <label>Player name</label>
        <input
          type="text"
          placeholder="Your name"
          :value="playerName"
          @input="emit('update-player-name', $event.target.value)"
        />
      </div>
      <button class="secondary" :disabled="loading" @click="emit('join-room')">
        Join Room
      </button>
      <button class="ghost" :disabled="loading" @click="emit('refresh-room')">
        Refresh
      </button>
      <button class="primary" :disabled="loading" @click="emit('start-game')">
        Start Game
      </button>
    </div>

    <div class="room-info">
      <p><strong>Active Room:</strong> {{ roomId || "-" }}</p>
      <div>
        <strong>Players:</strong>
        <ul>
          <li v-if="!players.length">No players yet.</li>
          <li v-for="player in players" :key="player.id">
            {{ player.name }}
          </li>
        </ul>
      </div>
    </div>

    <p v-if="error" class="error">{{ error }}</p>
  </section>
</template>
