<template>
  <q-layout class="flex flex-center">
    <div class="column">
      <div class="row">
        <h5 class="text-h5 text-white q-my-md">Company & Co</h5>
      </div>
      <div class="row">
        <q-card square bordered class="q-pa-lg shadow-1">
          <div v-if="!registerActive">
            <q-card-section>
              <q-form class="q-gutter-md">
                <q-input square filled clearable v-model="email" type="email" label="Email" />
                <q-input square filled clearable v-model="password" type="password" label="Password" />
              </q-form>
            </q-card-section>
            <q-card-actions class="q-px-md">
              <q-btn unelevated color="primary" size="lg" class="full-width" label="Login" @click="login()" />
            </q-card-actions>

            <q-card-section class="text-center q-pa-none">
              <p>Don't have an account? <a href="#" @click="registerActive = !registerActive, emptyFields = false">Sign up here</a> </p>
            </q-card-section>
          </div>
          <div v-else>
            <q-card-section>
              <q-form class="q-gutter-md">
                <q-input square filled clearable v-model="email" type="email" label="Email" />
                <q-input square filled clearable v-model="password" type="password" label="Password" />
                <q-input square filled clearable v-model="passwordConfirm" type="password" label="Confirm Password" />
              </q-form>
            </q-card-section>
            <q-card-actions class="q-px-md">
              <q-btn unelevated color="primary" size="lg" class="full-width" label="Signup" @click="signup()" />
            </q-card-actions>

            <q-card-section class="text-center q-pa-none">
              <p>Already have an account? <a href="#" @click="registerActive = !registerActive, emptyFields = false">Login in here</a> </p>
            </q-card-section>
          </div>
          <q-dialog v-if="errors.length > 0" v-model="error">
            <q-card>
              <q-card-section>
                <div class="text-h6">Alert</div>
              </q-card-section>

              <q-card-section class="q-pt-none">
                <div v-for="(error) in errors" :key="error.id">
                  {{ error }}
                </div>
              </q-card-section>

              <q-card-actions align="right">
                <q-btn flat label="OK" color="primary" v-close-popup />
              </q-card-actions>
            </q-card>
          </q-dialog>
        </q-card>
      </div>
    </div>
  </q-layout>
</template>

<script>
// import PocketBase from 'pocketbase';
import { pb } from '@/pocketbase/pocketbase';

export default {
  name: 'LoginA',
  data() {
    return {
      email: '',
      password: '',
      passwordConfirm: '',
      errors: [],
      error: false,
      registerActive: false,
    }
  },
  methods: {
    async login() {
      this.errors = [];
      this.error = false;
      try {
        await pb.collection('users').authWithPassword(
          this.email,
          this.password,
        );
        if(pb.authStore.isValid) {
          this.$router.push('/');
        }
      } catch (error) {
        this.errors.push(error.message);
        this.error = true;
      }
    },
    async signup() {
      this.errors = [];
      this.error = false;
      try {
        const data = {
            "email": this.email,
            "emailVisibility": true,
            "password": this.password,
            "passwordConfirm": this.passwordConfirm,
            "balance": 0
        };
        
        await pb.collection('users').create(data);
        this.registerActive = false;
      } catch (error) {
        this.errors.push(error.message);
        this.error = true;
      }

    }
  },
}




</script>

<style>
.q-card {
  width: 360px;
}
</style>