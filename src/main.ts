import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import PrimeVue from 'primevue/config'
import SelectButton from 'primevue/selectbutton';
import InputNumber from 'primevue/inputnumber';
import Card from 'primevue/card';

import 'primevue/resources/themes/md-dark-indigo/theme.css';
import 'primevue/resources/primevue.min.css';

/* import the fontawesome core */
import { library } from '@fortawesome/fontawesome-svg-core'

/* import font awesome icon component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

/* import specific icons */
import { faFilterCircleDollar, faMoneyBillTransfer, faCircleCheck } from '@fortawesome/free-solid-svg-icons';

/* add icons to the library */
library.add(faFilterCircleDollar, faMoneyBillTransfer, faCircleCheck );


const app = createApp(App)

app.use(router)
app.use(PrimeVue)

app.component('SelectButton', SelectButton);
app.component('InputNumber', InputNumber);
app.component('Card', Card);
app.component('font-awesome-icon', FontAwesomeIcon)
app.mount('#app')
