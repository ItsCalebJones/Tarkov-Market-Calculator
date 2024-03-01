<template>
  <div class="about">
    <Card style="width: 25rem; overflow: hidden">
      <template #title>
        <div class="title">About Me</div>
      </template>
      <template #subtitle>
        <div class="subtitle">@ItsCalebJones</div>
      </template>
      <template #content>
        <p class="m-0">
          I made this to solve a small problem with converting currencies in Escape from Tarkov. I hope you find it useful!
          Please feel free to follow me on <a href="https://github.com/ItsCalebJones">GitHub</a> and check out my other projects.
        </p>
      </template>
    </Card>
  </div>
</template>

<style>
@media (min-width: 1024px) {
  .about {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
  }
}
</style>
