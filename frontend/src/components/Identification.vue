<template>
    <div class="identification">
        <div class="card">
            <div class="card-body">
                <h2 v-if="isLoginForm">Identificationsss</h2>
                <h2 v-else>Registration</h2>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input id="username" type="text" class="form-control" v-model="formData.username" />
                </div>
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <input id="email" type="email" class="form-control" v-model="formData.email" />
                </div>
                <div v-if="isLoginForm" class="button-container">
                    <button @click="submitForm" class="btn btn-primary">Log In</button>
                    <div @click="updateLoginForm" class="account">Do not have an account ?</div>
                </div>
                <div v-else class="button-container">
                    <button @click="createUser" class="btn btn-primary">Register</button>
                    <div @click="updateLoginForm" class="account">Already have an account ?</div>
                </div>
            </div>
        </div>
    </div>
</template>
  
<script>
import { GET, POST } from "../api/axios"
import { ENDPOINTS } from "../api/endpoints"
import { createToast } from 'mosha-vue-toastify';

export default {
    name: 'Identification',
    data() {
        return {
            formData: {
                username: '',
                email: ''
            },
            isLoginForm: true
        };
    },
    methods: {
        submitForm() {
            GET(ENDPOINTS.GET_USER_BY_EMAIL_USERNAME, this.formData)
                .then((response) => {
                    createToast({ title: 'Sign IN Success', description: 'You are sucessfully connected' }, { type: 'success', position: 'bottom-right' });
                    localStorage.setItem('user', response.data.data.id)
                    this.$emit('authentication')
                })
                .catch((error) => {
                createToast({ title: 'Register Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
                })
        },
        createUser() {
            const user = {
                user: {
                    username: this.formData.username,
                    email: this.formData.email
                }
            }
            POST(ENDPOINTS.CREATE_USER, user)
            .then((response) => {
                createToast({ title: 'Register Success', description: 'You are sucessfully connected' }, { type: 'success', position: 'bottom-right' });
                localStorage.setItem('user', response.data.data.id)
                this.$emit('authentication')
            })
            .catch((error) => {
                createToast({ title: 'Register Failed', description: 'Please try again' }, { type: 'danger', position: 'bottom-right' });
            })
        },
        updateLoginForm() {
            this.isLoginForm = !this.isLoginForm
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
    padding: 10px 20px;
    font-size: 18px;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-primary {
    background-color: #3a669f;
}

.btn-primary:hover {
  background-color: #504ba9;
}

.account {
    margin-top: 0.5rem;
    cursor: pointer;
}

.account:hover {
    color: #007BFF;
}
</style>
  
