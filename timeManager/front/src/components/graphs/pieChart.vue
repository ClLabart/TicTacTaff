<template>
  <div>
    <canvas ref="chartCanvas" class="bg-white"></canvas>
  </div>
</template>

<script>
import { Chart, PieController, CategoryScale, LinearScale, BarElement, Title } from 'chart.js';

Chart.register(PieController, CategoryScale, LinearScale, BarElement, Title);

export default {

};

</script>

<style scoped>

</style>