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

const inputValue = ref(1000)
const currencies = ref<Currency[]>([
    { name: '₽ Rubles', iso: "RUB", id: 1, description: "Rubles", conversion: 1000, symbol: "₽", initialValue: 1000},
    { name: '$ USD', iso: "USD", id: 2, description: "USD", conversion: 130, symbol: "$", initialValue: 100},
    { name: '€ Euro', iso: "EUR", id: 3, description: "Euro", conversion: 138, symbol: "€", initialValue: 100}
]);
var sourceCurrency = ref(currencies.value[0]);
var targetCurrencies = ref(currencies.value.filter(currency => currency !== sourceCurrency.value));
var targetCurrency = ref(targetCurrencies.value[0]);


watch(sourceCurrency, (newValue) => {
  targetCurrencies.value = currencies.value.filter(currency => currency !== sourceCurrency.value);
  targetCurrency.value = targetCurrencies.value[0];
  if (!userInputReceived.value){
    inputValue.value = newValue.initialValue;
  }
});


const setInputReceived = () => {
  userInputReceived.value = true;
};

const getConvertedValue = () => {
  let finalValue = 0;

  const sourceId = sourceCurrency.value.id;
  const targetId = targetCurrency.value.id;
  const inputValueNumber = Number(inputValue.value);

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
    <h2> <b>{{ getConvertedValue() }}</b></h2>
  </StepItem>
</template>
