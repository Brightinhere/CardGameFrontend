<script setup>
const props = defineProps({
  dealer: Object
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
  <div class="dealer">
    <div class="dealer-header">
      <h3>Dealer</h3>
      <span class="status">{{ dealer.blackjack ? "Blackjack" : dealer.bust ? "Bust" : "" }}</span>
    </div>
    <div class="hand">
      <div
        v-for="(card, index) in dealer.cards"
        :key="index"
        class="card-item"
        :class="{ red: card.suit === 'HEARTS' || card.suit === 'DIAMONDS' }"
      >
        <div class="card-rank">{{ rankLabel(card.rank) }}</div>
        <div class="card-suit">{{ suitSymbol(card.suit) }}</div>
      </div>
    </div>
    <div class="hand-meta">
      <span>Value: {{ dealer.value }}</span>
    </div>
  </div>
</template>
