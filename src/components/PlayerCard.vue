<script setup>
const props = defineProps({
  player: Object,
  isCurrent: Boolean
});

const suitSymbol = (suit) =>
  ({
    HEARTS: "♥",
    DIAMONDS: "♦",
    CLUBS: "♣",
    SPADES: "♠"
  }[suit] || "?");

const rankLabel = (rank) =>
  ({
    ACE: "A",
    KING: "K",
    QUEEN: "Q",
    JACK: "J",
    TEN: "10",
    NINE: "9",
    EIGHT: "8",
    SEVEN: "7",
    SIX: "6",
    FIVE: "5",
    FOUR: "4",
    THREE: "3",
    TWO: "2"
  }[rank] || "?");
</script>

<template>
  <div class="player-card" :class="{ current: isCurrent }">
    <div class="player-header">
      <h3>{{ player.name }}</h3>
      <span class="status">{{ player.status }}</span>
    </div>
    <div class="hand">
      <div
        v-for="(card, index) in player.hand.cards"
        :key="index"
        class="card-item"
        :class="{ red: card.suit === 'HEARTS' || card.suit === 'DIAMONDS' }"
      >
        <div class="card-rank">{{ rankLabel(card.rank) }}</div>
        <div class="card-suit">{{ suitSymbol(card.suit) }}</div>
      </div>
    </div>
    <div class="hand-meta">
      <span>Value: {{ player.hand.value }}</span>
      <span v-if="player.hand.blackjack" class="flag">Blackjack</span>
      <span v-if="player.hand.bust" class="flag bust">Bust</span>
    </div>
  </div>
</template>
