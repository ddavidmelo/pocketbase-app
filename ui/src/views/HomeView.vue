<template>
  <q-layout view="lHh Lpr lFf">

    <ToolBar />

    <q-page-container>
      <BalanceTable v-if="balancePage" />
      <CreditForm v-if="creditPage" />
      <DebitForm v-if="debitPage" />
    </q-page-container>

</q-layout>
</template>

<script>
import BalanceTable from '@/components/BalanceTable.vue'
import ToolBar from '@/components/ToolBar.vue'
import CreditForm from '@/components/CreditForm.vue'
import DebitForm from '@/components/DebitForm.vue'

export default {
  name: 'LayoutDefault',

  components: {
    ToolBar,
    BalanceTable,
    CreditForm,
    DebitForm
  },
  computed: {
    balancePage() {
      if (this.$route.path == "/" || this.$route.path == "/home") {
        return true
      } else {
        return false
      }
    },
    creditPage() {
      if (this.$route.path == "/credit") {
        return true
      } else {
        return false
      }
    },
    debitPage() {
      if (this.$route.path == "/debit") {
        return true
      } else {
        return false
      }
    },
  },
  mounted() {
  },
  methods: {
  },
}
</script>
