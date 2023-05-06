<template>
    <q-header elevated>
        <q-toolbar class="text-white">
            <q-toolbar-title>
              <q-btn flat dense to="/">
                Home
            </q-btn>
            </q-toolbar-title>
            <q-tabs v-model="tab" active-color="blue" indicator-color="blue" narrow-indicator>
              <q-route-tab exact name="pay" label="Pay" to="/credit" />
              <q-route-tab exact name="buy" label="Buy" to="/debit" />
              <q-tab name="tab3" label="Logout" @click="logout()" />
            </q-tabs>
        </q-toolbar>
    </q-header>
</template>

<script>
import { pb } from '@/pocketbase/pocketbase';
import { ref } from 'vue'

export default {
  name: 'ToolBar',
  methods: {
    logout() {
      pb.authStore.clear();
      this.$router.push('/login');
    }
  },
  setup () {
    return {
      tab: ref('')
    }
  }
}
</script>
