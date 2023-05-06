<template>
  <q-page class="flex flex-center">

    <q-card class="card">
      <q-form @submit="onSubmit" class="q-gutter-md q-ma-md">

        <q-input filled type="price" v-model="amount" label="Money that you want to charge" lazy-rules :rules="[
            val => val !== null && val !== '' || 'Please type the amount',
            val => val > 0 && val < 100 || 'Please type a real amount'
          ]" prefix="€" />


        <div class="row justify-center">
          <q-btn class="q-ma-sm" label="Start Camera" id="start-camera" color="primary" @click="startVideo()" />
          <q-btn class="q-ma-sm" label="Click Photo" id="click-photo" color="primary" @click="takePhoto()" />
        </div>
        <video v-show=showVideo id="video" width="320" height="240" autoplay></video>
        <canvas v-show=showPhoto id="canvas" width="320" height="240"></canvas>

        <p class="row justify-center" style="color: grey">OR</p>

        <q-file outlined v-model="photo">
          <template v-slot:prepend>
            <q-icon name="attach_file" />
          </template>
        </q-file>
        <div>
          <q-btn :disable=submitDisable label="Submit" type="submit" color="primary" />
        </div>
      </q-form>
    </q-card>

    <q-dialog v-if="messages.length > 0" v-model="message">
      <q-card>
        <q-card-section>
          <div class="text-h6">Thank you</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <div v-for="(message) in messages" :key="message.id">
            {{ message }}
          </div>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Home" to="/" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>

  </q-page>
</template>

<style></style>

<script>
import { pb } from '@/pocketbase/pocketbase';

export default {
  name: 'CreditF',
  data() {
    return {
      amount: 1,
      photo: null,
      messages: [],
      message: false,
      showPhoto: false,
      showVideo: false,
      submitDisable: true
    }
  },
  methods: {
    async onSubmit() {
      console.log(this.photo);
      this.messages = [];
      this.message = false;
      var pocketbase_auth = JSON.parse(localStorage.getItem('pocketbase_auth'));


      const formData = new FormData();

      // set some other regular text field value
      formData.append('photo', this.photo);
      formData.append('amount', this.amount);
      formData.append('user', pocketbase_auth.model.id);
      // upload and create new record
      await pb.collection('transactions').create(formData);
      console.log(this.photo);
      this.messages.push("Charged amount: "+this.amount+"€");
      this.message = true;
    },
    async takePhoto() {
      this.showPhoto = true;
      this.showVideo = false;
      let video = document.querySelector("#video");
      let canvas = document.querySelector("#canvas");
      canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
      var teste = new Promise((resolve) => {
        canvas.toBlob(async function (blob) {
          let file = new File([blob], "fileName.jpg", { type: "image/jpeg" })
          resolve(file);
        }, 'image/jpeg')
      });
      this.photo = await teste;
    },
    async startVideo() {
      this.showPhoto = false;
      this.showVideo = true;

      let video = document.querySelector("#video");
      let stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
      video.srcObject = stream;
    }
  },
  watch: {
    photo() {
      if (this.photo != null) {
        this.submitDisable = false;
      }
    }
  }
}
</script>

<style>
.card {
  width: 50% !important;
  margin: 5px;
}

@media only screen and (max-width: 600px) {
  .card {
    width: 100% !important;
    margin: 5px;
  }
}
</style>