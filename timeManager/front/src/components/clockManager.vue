<template>
  <div>
    <button class="bg-transparent rounded border-2 border-black p-1.5" @click="clock">{{ "Pointer votre " + (!clockIn ? "arrivée" : "départ") }}</button>
    <p>{{ clockIn ? "Service en cours" : "Service en pause" }}</p>
    

    <div class="bg-transparent rounded border-2 border-black p-1.5 flex">
      <button :disabled=clockOut @click="clock">Pointer</button>
      <button :disabled=clockIn @click="clock">Stopper</button>
    </div>

    <div v-for="divItem in divs" :key="divItem.id" class="bg-slate-800 flex ">
      <p>Heure du pointage : {{ divItem.checkTime }}</p>
      <p>Heure de stop : {{ divItem.stopTime ? divItem.stopTime : '' }}</p>
      <p>Heure total de travail dans la journée : {{ divItem.totalHours +  }}</p>
    </div>


    
  </div>
  <div>

  </div>
  <!-- <div> 
    <div v-for="divItem in divs" :key="divItem.id" class="bg-slate-800 flex flex-col gap-y-4">
      <p class="text-white">Date du pointage : {{ divItem.checkTime }}</p>
      <p class="text-white">Temps passé en service : </p>
      <p class="text-white">Nombre de pointages de la journée : {{ divItem.clocksNumber }}</p>
    </div>
  </div> -->
</template>

<script>

export default {
  name: 'ClockManager',
  
  data() {
    return {
      
      startDatetime: null,
      endDatetime: null,
      numberOfClocks: 0,

      clockIn: false,
      clockOut: false,
      actualHour: null,
      totalHours: 0,
      stopHour: null,
      arrivedHour: null,
      countClockInOut: 0,
      userClocks: [],
      divs: [],

    }
  },

  async mounted() {

    // Récupération de la date actuelle
    this.actualHour = new Date();

    // Récupération de la liste des clocks d'un utilisateur de la journée actuelle
    await this.getClocks(1);
    let lastClock = this.userClocks[this.userClocks.length - 1];
    let lastClockDay = new Date(lastClock.time).getDate();

    if(lastClockDay != this.actualHour) {
      this.refresh()
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

    

    async getClocks(userId) {
      try {
        const response = await fetch('http://localhost:4000/api/clocks/' + userId);
        if (!response.ok) {
          throw new Error('Erreur du serveur');
        }
        const data = await response.json();

        this.userClocks = data.data;

        // console.log(data.data)

        // data.data.forEach(clock => {
        //   let milliseconds = Date.parse(clock.time)
        //   let time = this.formatDateTime(milliseconds)
        //   this.addDivClock(clock.id, time, this.numberOfClocks)
        // });

      } catch (error) {
        console.error('Error:', error);
      }
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

    // La fonction refresh() permet de remettre à null : startDatetime, endDatetime, clockIn
    // refresh() {
    //   this.startDatetime = null;
    //   this.endDatetime = null;
    //   this.clockIn = false;
    //   this.numberOfClocks = 0;
    // }, ANCIENNE

    refresh() {
      this.arrivedHour = null;
      this.stopHour = null;

      this.clockIn = false;
      this.clockOut = false;

      this.countClockInOut = 0;
    },

    // addDivClock(id, time, clocksNumber) {
    //   this.divs.push({ id: id, checkTime: time, clocksNumber: clocksNumber });
    // }, // ANCIENNE

    addDivClock(checkTime = 0, stopTime = null) {
      this.divs.push({ checkTime: checkTime, stopTime: stopTime });
    },

    createDatetime() {
      const actualDate = new Date();
      actualDate.setUTCHours(actualDate.getUTCHours() + 2);
      return actualDate.toISOString();
    },

    // La fonction clock() permet de changer d'état la pointeuse 
    async clock() {

      // Si la session de travail est en cours
      if(this.clockIn && this.clockOut === false) {

        // Affichage de l'heure actuelle
        this.stopHour = new Date().toLocaleTimeString('fr-FR')

        

        // Calculer les heures de travail effectuées de la période d'arrivée à stop
        // en retournant le bon format pour affichage
        let hour = this.stopHour - this.arrivedHour;



        this.addDivClock(this.arrivedHour,this.stopHour, hour);


        



      }

      // Si la session de travail est arrêtée
      if(this.clockOut && this.clockIn === false) {
        this.clockIn = !this.clockIn;
        this.clockOut = !this.clockOut;


        if(this.countClockInOut === 2) {
          this.refresh()
          this.arrivedHour = new Date()

          

          // Faire nouvelle div
          this.addDivClock()
          this.actualHour = new Date()
        }
        else {
          this.countClockInOut++;

        }

      }
      
      
      // 2. On regarde l'état de la pointeuse
      if(this.clockIn == false) {

        // Cas : Lorsque l'utilisateur pointe
        this.clockIn = !this.clockIn
        // this.startDatetime = this.createDatetime();
        this.startDatetime = new Date().toISOString();
        // this.numberOfClocks++;

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

