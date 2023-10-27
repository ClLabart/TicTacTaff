<template>
  <div>
    <canvas ref="chartCanvas"></canvas>
  </div>
</template>

<script>
import { Chart, BarController, CategoryScale, LinearScale, BarElement, Title } from 'chart.js';

Chart.register(BarController, CategoryScale, LinearScale, BarElement, Title);

export default {
  name: 'BarChart',
  props: {
    chartData: {
      type: Object,
      required: true
    },
    options: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      myChart: null
    }
  },
  watch: {
    chartData: {
      handler: 'drawChart',
      deep: true,
    },
    options: {
      handler: 'drawChart',
      deep: true,
    }
  },
  mounted() {
    this.drawChart();
  },
  methods: {
    drawChart() {
      if (this.myChart) {
        this.myChart.destroy();
      }
      if (!this.$refs.chartCanvas) {
        return;
      }
      this.myChart = new Chart(this.$refs.chartCanvas, {
        type: 'bar',
        data: this.chartData,
        options: this.options
      });
    }
  }
}
</script>
