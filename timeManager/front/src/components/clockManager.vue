<template>
  <div>
    <button class="bg-transparent rounded border-2 border-black p-1.5" @click="clock">{{ "Pointer votre " + (!clockIn ? "arrivée" : "départ") }}</button>
    <p>{{ clockIn ? "Service en cours" : "Service en pause" }}</p>
  </div>
  <div>

  </div>
  <div> 
    <div v-for="divItem in divs" :key="divItem.id" class="bg-slate-800 flex flex-col gap-x-4">
      <p class="text-white">Date du pointage : {{ divItem.checkTime }}</p>
      <p class="text-white">Temps passé en service : </p>
      <p class="text-white">Nombre de pointages de la journée : {{ divItem.clocksNumber }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ClockManager',
  data() {
    return {
      clockIn: false,
      startDatetime: null,
      endDatetime: null,
      numberOfClocks: 0,
      divs : [],
    }
  },
  methods: {

    async postClock(userId, status, time) {
      const requestOptions = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ "clock": {status: status, time: time}  })
      };
      const response = await fetch("http://localhost:4000/api/clocks/" + userId, requestOptions);
      const data = await response.json();
      console.log(data)
    },

    formatDateTime(milliseconds) {
      const date = new Date(milliseconds);

      const year = date.getUTCFullYear();
      const month = (date.getUTCMonth() + 1).toString().padStart(2, '0');
      const day = date.getUTCDate().toString().padStart(2, '0');
      const hours = date.getUTCHours().toString().padStart(2, '0');
      const minutes = date.getUTCMinutes().toString().padStart(2, '0');
      const seconds = date.getUTCSeconds().toString().padStart(2, '0');

      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    },

    async getClocks(userId) {
      try {
        const response = await fetch('http://localhost:4000/api/clocks/' + userId);
        if (!response.ok) {
          throw new Error('Erreur du serveur');
        }
        const data = await response.json();
        console.log(data.data)

        data.data.forEach(clock => {
          let milliseconds = Date.parse(clock.time)
          let time = this.formatDateTime(milliseconds)
          this.addDivClock(clock.id, time, this.numberOfClocks)
        });

      } catch (error) {
        console.error('Error:', error);
      }
    },

    // La fonction refresh() permet de remettre à null : startDatetime, endDatetime, clockIn
    refresh() {
      this.startDatetime = null;
      this.endDatetime = null;
      this.clockIn = false;
      this.numberOfClocks = 0;
    },

    addDivClock(id, time, clocksNumber) {
      this.divs.push({ id: id, checkTime: time, clocksNumber: clocksNumber });
    },

    createDatetime() {
      const actualDate = new Date();
      actualDate.setUTCHours(actualDate.getUTCHours() + 2);
      return actualDate.toISOString();
    },

    // La fonction clock() permet de changer d'état la pointeuse 
    async clock() {

      // 1. A chaque clique sur la pointeuse, on vérifie si c'est une nouvelle journée ou non
      let actualDate = this.createDatetime();
      const dateObject = new Date(actualDate);
      const dayActualDate = dateObject.getDate();

      let startClock = this.startDatetime;
      const dateObject2 = new Date(startClock)
      const dayStartClock = dateObject2.getDate()

      if(dayActualDate != dayStartClock) {
        console.log("0")
        // 1.1 Si c'est une nouvelle journée, on reset toute les variables
        this.refresh()
        // 1.2 On efface l'affichage des informations des pointeurs de la journée précédente
        this.divs = []
      }
      
      
      // 2. On regarde l'état de la pointeuse
      if(this.clockIn == false) {

        // Cas : Lorsque l'utilisateur pointe
        this.clockIn = !this.clockIn
        this.startDatetime = this.createDatetime();
        this.numberOfClocks++;

        console.log("startDatetime :", this.startDatetime)
        console.log("clockIn :", this.clockIn)

        this.divs = []
        

        await this.postClock(1, this.clockIn, this.startDatetime) // Besoin de récupérer l'id de l'utilisateur


        await this.getClocks(1)
        // Besoin de récupérer l'id de l'utilisateur
      
      }
      else {
        // Cas : Lorsque l'utilisateur dépointe
        this.clockIn = !this.clockIn
        this.endDatetime = this.createDatetime();
        this.numberOfClocks++;

        this.divs = []

        console.log("startDatetime :", this.startDatetime)
        console.log("endDatetime :", this.endDatetime)
        console.log("clockIn :", this.clockIn)

        this.postClock(1, this.clockIn, this.endDatetime) // Besoin de récupérer l'id de l'utilisateur

        this.getClocks(1) // Besoin de récupérer l'id de l'utilisateur
        

      }
      
    } 
  
  }
}

</script>

<style scoped>

</style>

