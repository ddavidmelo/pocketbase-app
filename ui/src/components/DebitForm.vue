<template>
  <q-page class="flex flex-center">

    <q-card class="card">
      <q-form @submit="onSubmit" class="q-gutter-md q-ma-md">
        <q-select filled v-model="unitPrice" :options="unitPriceOptions" label="Unit price" prefix="€" />
        <q-input filled type="number" v-model="amount" label="Units that you want to buy" lazy-rules :rules="[
            val => val !== null && val !== '' || 'Please type the amount',
            val => val > 0 && val < 100 || 'Please type a real amount'
          ]" />
        <div>
          <q-btn label="Buy" type="submit" color="primary" />
        </div>
      </q-form>
    </q-card>

    <q-dialog v-if="messages.length > 0" v-model="message">
      <q-card>
        <q-card-section>
          <div class="text-h6">Thank you!</div>
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
  name: 'DebitF',
  data() {
    return {
      amount: 1,
      messages: [],
      message: false,
      unitPrice: 0.5,
      unitPriceOptions: [
        0.5
      ]
    }
  },
  methods: {
    async onSubmit() {
      try {
        this.messages = [];
        this.message = false;
        var pocketbase_auth = JSON.parse(localStorage.getItem('pocketbase_auth'));
        var data = {
          "amount": -this.amount * this.unitPrice,
          "user": pocketbase_auth.model.id
        };

        await pb.collection('transactions').create(data);
        this.messages.push("You paid: " + this.amount * 0.5 + "€");
        this.message = true;
      } catch (error) {
        console.log(error);
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