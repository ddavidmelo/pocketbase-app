<template>
  <q-page class="flex flex-center">

    <q-card class="card">
      <q-card-section horizontal class="row justify-center items-center">
        <q-icon class="q-pa-md" name="payments" color="secondary" size="4rem" />
        <q-space />

        <q-item v-ripple>
          <q-chip color="secondary" class="balance-text">
            Current balance
            <q-chip  color="primary" text-color="white" class="balance-number">
              {{ balance }} €
            </q-chip>
          </q-chip>

        </q-item>

      </q-card-section>

      <q-separator />
      <q-table :rows="rows" :columns="columns" v-model:pagination="pagination" row-key="name" bordered
        @request="onRequest" />

    </q-card>

  </q-page>
</template>

<style></style>

<script>
import { pb } from '@/pocketbase/pocketbase';

export default {
  name: 'LoginA',
  data() {
    return {
      balance: 0,
      rows: [],
      columns: [
        { label: 'amount', field: 'amount', format: (val) => `${val}€`, style: 'color: blue; font-weight: bold', align: 'left' },
        { label: 'updated', field: 'updated', name: 'updated' },
      ],
      pagination: {
        sortBy: 'updated',
        descending: true,
        page: 1,
        rowsPerPage: 5,
        rowsNumber: 11
      },
      loading: false,
    }
  },
  methods: {
    async onRequest(props) {
      const { page, rowsPerPage } = props.pagination
      this.loading = true
      

      var pocketbase_auth = JSON.parse(localStorage.getItem('pocketbase_auth'));
      var transactions = await pb.collection('transactions').getList(page, rowsPerPage, { filter: 'user="' + pocketbase_auth.model.id + '"', sort: '-updated' });
      this.rows = transactions.items
      
      this.pagination.rowsPerPage = rowsPerPage;
      this.pagination.page = page
      this.pagination.rowsNumber = transactions.totalItems
      this.loading = false
    }
  },
  async mounted() {

    this.onRequest({
      pagination: this.pagination
    })

    var pocketbase_auth = JSON.parse(localStorage.getItem('pocketbase_auth'));
    const balance = await pb.collection('users').getFirstListItem('id="' + pocketbase_auth.model.id + '"', {});
    this.balance = balance.balance;


  },
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

.balance-text {
  font-weight: bold;
  font: 18px Arial, Helvetica, sans-serif;
}

</style>