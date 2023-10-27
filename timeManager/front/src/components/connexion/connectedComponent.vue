<template>
    <!-- <navbar>
        <NavbarComponent />
    </navbar> -->
    <main>
        <UserComponent />
        <!-- <WorkingTime />
        <WorkingTimes />
        <ChartManager />
        <ClockManager /> -->
    </main>
</template>

<script>
// import NavbarComponent from "@/components/layout/navbarComponent.vue";
import UserComponent from "@/components/userComponent.vue";
// import ChartManager from "@/components/chartManager.vue";
// import ClockManager from "@/components/clockManager.vue";
// import WorkingTime from "@/components/workingTime.vue";
// import WorkingTimes from "@/components/workingTimes.vue";

export default {
    name: "ConnectedComponent",
    components: {
        // NavbarComponent,
        UserComponent,
        // ChartManager,
        // ClockManager,
        // WorkingTime,
        // WorkingTimes,
    },
};
</script>

<style scoped></style>
