<template>
  <div>
    <h2>{{user.username}}</h2>
    <h3>{{user.email}}</h3>
  </div>
</template>

<script>
export default {
  name: 'CardUserWorkingTimes',
  props: {
    user: {
      type: Object,
      required: true
    }
  },
}
</script>

<style scoped>

</style>