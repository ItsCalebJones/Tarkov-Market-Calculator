<script setup lang="ts">
import StepItem from './StepItem.vue'
import { watch } from 'vue';
import { ref } from 'vue';

interface Currency {
  id: number;
  name: string;
  iso: string;
  description: string;
  conversion: number;
  symbol: string;
  initialValue: number;
}

const userInputReceived = ref(false);

let data = ref(null);
let euroCurrencyConversion = ref(10);
let dollarCurrencyConversion = ref(10);



const inputValue = ref(1000)

const rublesCurrency: Currency = {
  name: '₽ Rubles',
  iso: "RUB",
  id: 1,
  description: "Rubles",
  conversion: 1000,
  symbol: "₽",
  initialValue: 1000
};

var dollarCurrency: Currency = {
  name: '$ USD',
  iso: "USD",
  id: 2,
  description: "USD",
  conversion: dollarCurrencyConversion.value,
  symbol: "$",
  initialValue: 100
};

watch(dollarCurrency, (newValue) => {
  console.log(newValue);
});

var euroCurrency: Currency = {
  name: '€ Euro',
  iso: "EUR",
  id: 3,
  description: "Euro",
  conversion: euroCurrencyConversion.value,
  symbol: "€",
  initialValue: 100
};

watch(euroCurrency, (newValue) => {
  console.log("updating something");
  console.log(newValue);
});

// const { data, error } = useSWRV('https://api.eft-calculator.com/api/tarkov_item/', fetcher)
const fetchData = async () => {
  try {
    const response = await fetch('https://api.eft-calculator.com/api/tarkov_item/');
    data.value = await response.json();
    if (data.value) {
      euroCurrencyConversion.value = (data.value as { base_price: number }[])[0]?.base_price || 0;
      dollarCurrencyConversion.value = (data.value as { base_price: number }[])[1]?.base_price || 0;
    }
    dollarCurrency = {
      ...dollarCurrency,
      conversion: dollarCurrencyConversion.value,
    };
    euroCurrency = {
      ...euroCurrency,
      conversion: euroCurrencyConversion.value,
    };
      // Update the currencies array to include the new currency objects
      currencies.value = [rublesCurrency, dollarCurrency, euroCurrency];
      sourceCurrency.value = currencies.value[0]
      targetCurrencies.value = currencies.value.filter(currency => currency !== sourceCurrency.value)
      targetCurrency.value = targetCurrencies.value[0]
  } catch (error) {
    console.error('Error fetching data:', error);
  }
};

fetchData();

watch(() => [dollarCurrency.conversion, euroCurrency.conversion], () => {
  console.log("Conversion rates updated");
  // Perform any additional logic if needed when conversion rates change
}, { deep: true });

const currencies = ref<Currency[]>([rublesCurrency, dollarCurrency, euroCurrency]);


var sourceCurrency = ref(currencies.value[0]);
var targetCurrencies = ref(currencies.value.filter(currency => currency !== sourceCurrency.value));
var targetCurrency = ref(targetCurrencies.value[0]);

watch(currencies, (newValue) => {
  console.log("currencies updated " + newValue);
  targetCurrencies.value = currencies.value.filter(currency => currency !== sourceCurrency.value)
});

watch(targetCurrencies, (newValue) => {
  console.log("targetCurrency updated " + newValue);
  targetCurrency.value = targetCurrencies.value[0];
});

watch(sourceCurrency, (newValue) => {
  targetCurrencies.value = currencies.value.filter(currency => currency !== sourceCurrency.value);
  targetCurrency.value = targetCurrencies.value[0];

  if(newValue == null){
    sourceCurrency.value = currencies.value[0];
  } else {
    if (!userInputReceived.value){
      inputValue.value = newValue.initialValue;
    }
  }
});

watch(targetCurrency, (newValue) => {
  if(newValue == null){
    targetCurrency.value = targetCurrencies.value[0];
  }
});


const setInputReceived = () => {
  userInputReceived.value = true;
};

const getConvertedValue = () => {
  let finalValue = 0;

  let sourceId = sourceCurrency.value.id;
  let targetId = targetCurrency.value.id;
  let inputValueNumber = Number(inputValue.value);

  if (sourceId === 1) {
    // If source currency is rubles
    finalValue = inputValueNumber / targetCurrency.value.conversion;
  } else if (sourceId === 2 && targetId === 1) {
    // If the source currency is USD and the target currency is rubles
    finalValue = inputValueNumber * sourceCurrency.value.conversion;
  } else if (sourceId === 2 && targetId === 3) {
    // If the source currency is USD and the target currency is Euro
    finalValue = (inputValueNumber * sourceCurrency.value.conversion) / targetCurrency.value.conversion;
  } else if (sourceId === 3 && targetId === 1) {
    // If the source currency is Euro and the target currency is rubles
    finalValue = inputValueNumber * sourceCurrency.value.conversion;
  } else if (sourceId === 3 && targetId === 2) {
    // If the source currency is Euro and the target currency is USD
    finalValue = (inputValueNumber * sourceCurrency.value.conversion) / targetCurrency.value.conversion;
  } else {
    // For all other cases
    finalValue = inputValueNumber * targetCurrency.value.conversion;
  }

  const formattedValue = finalValue.toLocaleString('en-US', { maximumFractionDigits: 0 });
  return `Equivalent Flea Market value in ${targetCurrency.value.name} is ${targetCurrency.value.symbol}${formattedValue}.`;
};
</script>

<template>
  <StepItem>
    <template #icon>
      <font-awesome-icon icon="fa-solid fa-filter-circle-dollar" />
    </template>
    <template #heading>Initial Currency</template>

    Enter the initial currency to convert from.
    <div class="card flex flex-wrap gap-3 p-fluid">
        <div class="card flex justify-content-center">
            <SelectButton v-model="sourceCurrency" :options="currencies" optionLabel="name"/>
        </div>
        <br>
        <div class="flex-auto">
            <InputNumber v-model="inputValue" inputId="currency-us" mode="currency" :currency="sourceCurrency.iso" locale="en-US" @input="setInputReceived()" />
        </div>
    </div>
  </StepItem>

  <StepItem>
    <template #icon>
      <font-awesome-icon icon="fa-solid fa-money-bill-transfer" />
    </template>
    <template #heading>Target Currency</template>
    Select the currency to convert to.
    <div class="card flex justify-content-center">
            <SelectButton v-model="targetCurrency" :options="targetCurrencies" optionLabel="name"/>
    </div>

  </StepItem>
  <StepItem>
    <template #icon>
      <font-awesome-icon icon="fa-solid fa-circle-check" />
    </template>
    <template #heading>Output</template>
    <h2 v-if="{targetCurrency}"> <b>{{ getConvertedValue() }}</b></h2>
    <h1 v-else>Oh no 😢</h1>
  </StepItem>
</template>
