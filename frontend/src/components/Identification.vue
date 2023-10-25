<template>
    <div class="identification">
        <div class="card">
            <div class="card-body">
                <h2>Identification</h2>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input id="username" type="text" class="form-control" v-model="formData.username" />
                </div>
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <input id="email" type="email" class="form-control" v-model="formData.email" />
                </div>
                <div class="button-container">
                    <button @click="submitForm" class="btn btn-primary">Log In</button>
                </div>
            </div>
        </div>
    </div>
</template>
  
<script>
import { GET } from "../api/axios"
import { ENDPOINTS } from "../api/endpoints"

export default {
    name: 'Identification',
    data() {
        return {
            formData: {
                username: '',
                email: ''
            }
        };
    },
    methods: {
        submitForm() {
            GET(ENDPOINTS.GET_USER_BY_EMAIL_USERNAME, this.formData)
                .then((response) => {
                    this.$emit('data', response.data)
                })
                .catch((error) => { console.dir(error) })
        }
    }
}
</script>
  
<style scoped>
.identification {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.card {
    border: 1px solid #ccc;
    border-radius: 4px;
    padding: 16px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.form-group {
    margin: 10px 0;
}

.form-control {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.button-container {
    text-align: right;
    margin-top: 20px;
}

.btn {
    background-color: #007BFF;
    color: #fff;
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}
</style>
  