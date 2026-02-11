<script setup>
import DealerSection from "./DealerSection.vue";
import PlayerCard from "./PlayerCard.vue";

const props = defineProps({
  game: Object,
  players: Array,
  loading: Boolean,
  isMyTurn: Boolean,
  gameState: String
});

const emit = defineEmits(["hit", "stand"]);
</script>

<template>
  <section class="card">
    <div class="section-header">
      <h2>Game</h2>
      <span class="badge">{{ gameState }}</span>
    </div>

    <DealerSection :dealer="game.dealer" />

    <div class="players">
      <PlayerCard
        v-for="player in players"
        :key="player.id"
        :player="player"
        :is-current="game.currentPlayerId === player.id"
      />
    </div>

    <div class="actions">
      <button
        class="primary"
        :disabled="loading || !isMyTurn || gameState !== 'IN_PROGRESS'"
        @click="emit('hit')"
      >
        Hit
      </button>
      <button
        class="secondary"
        :disabled="loading || !isMyTurn || gameState !== 'IN_PROGRESS'"
        @click="emit('stand')"
      >
        Stand
      </button>
    </div>

    <p v-if="!isMyTurn" class="hint">
      Waiting for your turn or game is not in progress.
    </p>
  </section>
</template>
