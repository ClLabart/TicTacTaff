<template>
  <div>
    <canvas ref="chartCanvas"></canvas>
  </div>
</template>

<script>
import { Chart, BarController, CategoryScale, LinearScale, BarElement, Title } from 'chart.js';
import {shallowRef} from "vue";

Chart.register(BarController, CategoryScale, LinearScale, BarElement, Title);

export default {
  name: 'BarChart',

  props: {
    chart: {
      type: Object,
      required: true
    },
  },

  data() {
    return {
      myChart: null
    }
  },

  mounted() {
    this.initializeChart();
  },

  beforeUpdate() {
    this.updateChartData();
  },

  methods: {
    initializeChart() {
      if (!this.$refs.chartCanvas) return;

      this.myChart = shallowRef(
          new Chart(this.$refs.chartCanvas, {
            type: 'bar',
            data: this.chart.data,
            options: this.chart.options
          })
      );
    },

    updateChartData() {
      if (!this.myChart) return;
      this.myChart.data.labels = JSON.parse(JSON.stringify(this.chart.data.labels));
      this.myChart.data.datasets = JSON.parse(JSON.stringify(this.chart.data.datasets));
      this.myChart.options = JSON.parse(JSON.stringify(this.chart.options));
      this.myChart.update();
    }
  }
}
</script>
