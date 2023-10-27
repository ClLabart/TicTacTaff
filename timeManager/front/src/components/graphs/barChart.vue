<template>
  <div>
    <canvas ref="chartCanvas"></canvas>
  </div>
</template>

<script>
import { Chart, BarController, CategoryScale, LinearScale, BarElement } from 'chart.js';

Chart.register(BarController, CategoryScale, LinearScale, BarElement);

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
      this.myChart = new Chart(this.$refs.chartCanvas, {
        type: 'bar',
        data: this.chartData,
        options: this.options
      });
    }
  }
}
</script>
