<script setup>
import { onMounted, onUnmounted, reactive } from "vue";
import RoomSection from "./components/RoomSection.vue";
import GameSection from "./components/GameSection.vue";

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8080";

const state = reactive({
  roomId: "",
  room: null,
  rooms: [],
  playerName: "",
  playerId: "",
  loading: false,
  error: "",
  autoRefresh: true
});

let refreshTimer = null;

const setError = (message) => {
  state.error = message || "";
};

const request = async (path, options = {}) => {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...(options.headers || {})
    },
    ...options
  });

  if (!response.ok) {
    let message = "Request failed";
    try {
      const data = await response.json();
      message = data?.message || JSON.stringify(data);
    } catch {
      try {
        message = await response.text();
      } catch {
        message = "Request failed";
      }
    }
    throw new Error(message);
  }

  return response.json();
};

const refreshRoom = async () => {
  if (!state.roomId) return;
  state.loading = true;
  try {
    const room = await request(`/rooms/${state.roomId}`);
    state.room = room;
    if (state.playerName) {
      const me = room.players?.find((p) => p.name === state.playerName);
      if (me) state.playerId = me.id;
    }
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const refreshRooms = async () => {
  state.loading = true;
  try {
    const rooms = await request(`/rooms/`);
    state.rooms = Array.isArray(rooms) ? rooms : [];
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const createRoom = async () => {
  state.loading = true;
  try {
    const room = await request("/rooms", { method: "POST" });
    state.room = room;
    state.roomId = room.id;
    await refreshRooms();
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const joinRoom = async () => {
  if (!state.roomId || !state.playerName) {
    setError("Room ID and player name are required.");
    return;
  }
  state.loading = true;
  try {
    const room = await request(
      `/rooms/${state.roomId}/join?name=${encodeURIComponent(state.playerName)}`,
      { method: "POST" }
    );
    state.room = room;
    const me = room.players?.find((p) => p.name === state.playerName);
    state.playerId = me?.id || "";
    await refreshRooms();
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const startGame = async () => {
  if (!state.roomId) return;
  state.loading = true;
  try {
    const room = await request(`/rooms/${state.roomId}/start`, { method: "POST" });
    state.room = room;
    await refreshRooms();
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const hit = async () => {
  if (!state.roomId || !state.playerId) return;
  state.loading = true;
  try {
    const room = await request(
      `/rooms/${state.roomId}/hit/${state.playerId}`,
      { method: "POST" }
    );
    state.room = room;
    await refreshRooms();
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const stand = async () => {
  if (!state.roomId || !state.playerId) return;
  state.loading = true;
  try {
    const room = await request(
      `/rooms/${state.roomId}/stand/${state.playerId}`,
      { method: "POST" }
    );
    state.room = room;
    await refreshRooms();
    setError("");
  } catch (error) {
    setError(error.message);
  } finally {
    state.loading = false;
  }
};

const gameState = () => state.room?.currentGame?.state || "WAITING_FOR_PLAYERS";
const isMyTurn = () =>
  state.room?.currentGame?.currentPlayerId &&
  state.room?.currentGame?.currentPlayerId === state.playerId;

const setupAutoRefresh = () => {
  clearInterval(refreshTimer);
  if (state.autoRefresh) {
    refreshTimer = setInterval(() => {
      refreshRoom();
      refreshRooms();
    }, 3000);
  }
};

onMounted(() => {
  refreshRooms();
  setupAutoRefresh();
});

onUnmounted(() => {
  clearInterval(refreshTimer);
});
</script>

<template>
  <div class="app">
    <header class="header">
      <h1>Blackjack</h1>
      <p class="subtitle">Minimal Vue client for the Blackjack API</p>
    </header>

    <RoomSection
      :rooms="state.rooms"
      :room-id="state.roomId"
      :player-name="state.playerName"
      :players="state.room?.players || []"
      :loading="state.loading"
      :error="state.error"
      :auto-refresh="state.autoRefresh"
      @select-room="state.roomId = $event; refreshRoom()"
      @update-room-id="state.roomId = $event"
      @update-player-name="state.playerName = $event"
      @toggle-refresh="state.autoRefresh = $event; setupAutoRefresh()"
      @create-room="createRoom"
      @join-room="joinRoom"
      @refresh-room="refreshRoom"
      @refresh-rooms="refreshRooms"
      @start-game="startGame"
    />

    <GameSection
      v-if="state.room?.currentGame"
      :game="state.room.currentGame"
      :players="state.room.currentGame.players"
      :loading="state.loading"
      :is-my-turn="isMyTurn()"
      :game-state="gameState()"
      @hit="hit"
      @stand="stand"
    />

    <div v-else class="empty-state">
      <p>Create or join a room to begin.</p>
    </div>
  </div>
</template>
