<template>
    <div>
      <div class="modal-overlay">
        <div class="modal-content">
            Hello
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'ModalTime',
    data() {
      return {
        // showModal: false,
      };
    },
    methods: {
      openModal() {
        this.showModal = true;
      },
      closeModal() {
        this.showModal = false;
      },
    },
  };
  </script>
  
  <style scoped>
  /* Style pour la superposition (overlay) */
  .modal-overlay {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    z-index: 1000;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.3s ease-in-out;
  }
  
  /* Style pour le contenu du modal */
  .modal-content {
    background: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    width: 80%;
    max-width: 400px;
    text-align: center;
    position: relative;
    opacity: 0;
    transform: translateY(-20px);
    transition: opacity 0.3s ease-in-out, transform 0.3s ease-in-out;
  }
  
  /* Animation de l'ouverture du modal */
  .modal-overlay.active {
    opacity: 1;
    pointer-events: auto;
  }
  
  .modal-content.active {
    opacity: 1;
    transform: translateY(0);
  }
  </style>
  