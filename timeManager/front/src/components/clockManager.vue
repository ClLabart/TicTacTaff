<template>
  <div>
    <div class="bg-transparent rounded  p-1.5 flex flex-col gap-5">
      <button class="border-2 border-black" @click="clock('pointer')">Pointer</button>
      <button class="border-2 border-black" @click="clock('stop')">Stopper</button>
    </div>
    <div>
      <p>{{  }}</p>
    </div>

    <div v-for="divItem in this.divs" :key="divItem.id" class="flex flex-col">
      <p>Heure du pointage : {{ divItem.checkTime }}</p>
      <p>Heure de stop : {{ divItem.stopTime }}</p>
    </div>

    <div>
      <p>Heures totales de travail dans la journée : {{ this.displayTotalHours != 0 ? buildTotalHour() : '' }}</p>
    </div>

  </div>
  <div>

  </div>
</template>

<script>

export default {
  name: 'ClockManager',
  
  data() {
    return {

      clockIn: false,
      clockOut: true,
      actualHour: 0,
      totalHours: 0,
      stopHour: 0,
      countClockInOut: 0,
      countClickStopButton: 0,
      clockID: 1,
      userClocks: [],
      divs: [],

    }
  },

  async mounted() {

    // Récupération de la date actuelle
    this.actualHour = new Date();
    let actualHourDay = this.actualHour.getDate();
    
    // Récupération de la liste des clocks d'un utilisateur de la journée actuelle
    await this.getClocks(1);
    
    if(!localStorage.getItem('clockTotalHours')) {
      localStorage.setItem('clockTotalHours','0')
    }

    // Si le tableau contient des clocks
    if(localStorage.getItem('clocksUser')) {
      
      this.totalHours = parseInt(localStorage.getItem('clockTotalHours')) 
      console.log(this.totalHours)
      this.divs = JSON.parse(localStorage.getItem('clocksUser'));
    }


    let lastClock = this.userClocks[this.userClocks.length - 1];
    let lastClockDay = new Date(lastClock.time).getDate();

    if(lastClockDay != actualHourDay) {
      this.refresh();
      this.divs = [];
      console.log("test2")
      localStorage.removeItem('clocksUser');
      localStorage.setItem('clockTotalHours', '0');
    }


   
  },

  computed: {
    displayTotalHours () {
      return this.totalHours
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

      } catch (error) {
        console.error('Error:', error);
      }
    },

    // La fonction refresh() permet de reset les valeurs des variables
    refresh() {

      this.stopHour = null;
      this.clockIn = false;
      this.clockOut = true;
      this.countClockInOut = 0;

    },

    // La fonction buildTime() permet de formater une date au bon format pour l'afficher
    buildTime(date) {
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      const secondes = date.getSeconds().toString().padStart(2, '0');
      const formatedHour = `${hours}h:${minutes}m:${secondes}s`;
      return formatedHour;
    },

    // La fonction buildTotalHour() permet de construire le temps total de travail de l'utilisateur au format : 'HH:mm:ss'
    buildTotalHour() {
      console.log(this.totalHours)
      const heures = Math.floor(this.totalHours / 3600000); // 1 heure = 3600000 millisecondes
      const minutes = Math.floor((this.totalHours % 3600000) / 60000); // 1 minute = 60000 millisecondes
      const secondes = Math.floor((this.totalHours % 60000) / 1000); // 1 seconde = 1000 millisecondes
      const tempsTotal = `${heures.toString().padStart(2, '0')}h${minutes.toString().padStart(2, '0')}m${secondes.toString().padStart(2, '0')}s`;
      return tempsTotal
    },

    // La fonction addDivClock() permet d'ajouter des données pour une nouvelle div d'affichage
    addDivClock(checkTime) {
      if(this.clockID != 1)
      {
        this.clockID++;
      }

      let formatedHour = this.buildTime(checkTime)
      let clockObject = {id: this.clockID, checkTime: formatedHour, stopTime: '00h00m00s'};
      this.divs.push(clockObject)

      if(localStorage.getItem('clocksUser')) {

        const clocksArray = JSON.parse(localStorage.getItem('clocksUser'));
        clocksArray.push(clockObject);
        const clocksArrayUpdate = JSON.stringify(clocksArray);
        localStorage.setItem('clocksUser', clocksArrayUpdate);

      }
      else {
        localStorage.setItem('clocksUser', JSON.stringify(this.divs));
      }     
    },

    // La fonction clock() permet de changer d'état la pointeuse 
    async clock(typeButton) {
      console.log(this.countClockInOut)

      // Si la session de travail est arrêtée
      if(typeButton === 'pointer')
      {
        
        if(this.clockOut && this.clockIn === false) {

          this.clockIn = true;
          this.clockOut = false;

          this.actualHour = new Date();


          if(this.countClockInOut === 2) {
            this.countClockInOut = 1;
            await this.postClock(1,this.clockIn, this.actualHour.toISOString())
            this.addDivClock(this.actualHour)
          }
          else {
            this.countClockInOut++;
            await this.postClock(1,this.clockIn, this.actualHour.toISOString())
            this.addDivClock(this.actualHour)
          }

          
          
        }
      }

      if(typeButton === 'stop') {

        // Si la session de travail est en cours
        if(this.clockIn && this.clockOut === false) {
          this.clockIn = false
          this.clockOut = true

          // Affichage de l'heure actuelle + Ajout du stopTime dans sa div d'affichage
          this.stopHour = new Date();
          this.divs[this.divs.length - 1].stopTime = this.buildTime(this.stopHour);

          if(localStorage.getItem('clocksUser')) {
            localStorage.setItem('clocksUser', JSON.stringify(this.divs));
          }
      
          this.countClockInOut++;
          this.countClickStopButton++;
          console.log('count stop button', this.countClickStopButton)
          

          this.totalHours += this.stopHour - this.actualHour
          this.countClickStopButton = 1;

          if(localStorage.getItem('clockTotalHours')) {
            
            let clockTotalHours = parseInt(localStorage.getItem('clockTotalHours'));
            console.log('total hours initial', clockTotalHours)
            clockTotalHours += this.stopHour - this.actualHour;
            console.log('total hours final', clockTotalHours)
            localStorage.setItem('clockTotalHours', clockTotalHours);

          }    
            
          
          // else {
          //   console.log('stop hours ', this.stopHour)
          //   console.log('actual hours ', this.actualHour)
          
          //   this.totalHours = this.stopHour - this.actualHour;
          //   localStorage.setItem('clockTotalHours', this.totalHours);
          //   console.log(this.totalHours)
            
          // }
          
          // Push le clock en BDD
          await this.postClock(1, false, this.stopHour.toISOString())
        }

      }
      
    } 
  
  }
}

</script>

<style scoped>

</style>

