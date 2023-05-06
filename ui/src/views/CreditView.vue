<template>
  <q-layout view="lHh Lpr lFf">

    <ToolBar v-if="creditPage" />

    <q-page-container>
      <BalanceTable />
    </q-page-container>

  </q-layout>
</template>

<script>
import BalanceTable from '@/components/BalanceTable.vue'
import ToolBar from '@/components/ToolBar.vue'

export default {
  name: 'LayoutDefault',

  components: {
    BalanceTable,
    ToolBar
  },
  computed: {
    creditPage() {
      if (this.$route.path == "/" || this.$route.path == "/credit") {
        return true
      } else {
        return false
      }
    }
  }
}
</script>
