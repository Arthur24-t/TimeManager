<template>
    <div class="identification">
        <div class="card">
            <div class="card-body">
                <div v-if="isLoginForm" class="title-container">
                    <h1>Log In</h1>
                    <p class="subtitle">Log in to your account with your email adress and your password</p>
                </div>
                <div v-else class="title-container">
                    <h1>Create An Account</h1>
                    <p class="subtitle">Create an account to access your time manager !</p>
                </div>
                <div class="form-group" v-if="!isLoginForm">
                    <input id="username" placeholder="Username" type="text" class="form-control" v-model="formData.username" />
                </div>
                <div class="form-group">
                    <input id="email" placeholder="Email Address" type="email" class="form-control" v-model="formData.email" />
                </div>
                <div class="form-group">
                    <input id="username" placeholder="Password" type="password" class="form-control" v-model="formData.password" />
                </div>
                <div v-if="isLoginForm" class="button-container">
                    <button @click="login" class="btn btn-primary">Log In</button>
                    <div class="account">Do not have an account ? <span @click="updateLoginForm" class="link">Sign Up</span></div>
                </div>
                <div v-else class="button-container">
                    <button @click="createUser" class="btn btn-primary">Create Account</button>
                    <div class="account">Already Have An Account? <span @click="updateLoginForm" class="link">Sign In</span></div>
                </div>
            </div>
        </div>
    </div>
</template>
  
<script>
import { POST } from "../api/axios"
import { ENDPOINTS } from "../api/endpoints"
import { createToast } from 'mosha-vue-toastify';
import CryptoJS from 'crypto-js';
export default {
    name: 'Identification',
    data() {
        return {
            formData: {
                username: '',
                password: '',
                email: '',
            },
            isLoginForm: true
        };
    },
    methods: {
        hashPassword(password) {
            return CryptoJS.SHA256(password).toString();
        },
        login() {
            const hashedPassword = this.hashPassword(this.formData.password);
            const user = {
                user: {
                    email: this.formData.email,
                    password: hashedPassword
                }
            }
            POST(ENDPOINTS.LOGIN_USER, user)
                .then((response) => {
                    createToast({ title: 'Sign IN Success', description: 'You are sucessfully connected' }, { type: 'success', position: 'bottom-right' });
                    localStorage.setItem('user', response.data.user.id)
                    localStorage.setItem('token', response.data.token)
                    this.$router.push('/home')
                })
                .catch((error) => {
                createToast({ title: 'Sign IN Failed', description: 'Please try again...' }, { type: 'danger', position: 'bottom-right' });
                })
        },
        createUser() {
            const hashedPassword = this.hashPassword(this.formData.password);
            const data = {
                user: {
                    username: this.formData.username,
                    email: this.formData.email,
                    password: hashedPassword,
                }
            }
            POST(ENDPOINTS.CREATE_USER, data)
            .then((response) => {
                createToast({ title: 'Register Success', description: 'You are sucessfully connected' }, { type: 'success', position: 'bottom-right' });
                localStorage.setItem('user', response.data.user.id)
                localStorage.setItem('token', response.data.token)
                this.$router.push('/home')
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
    border-radius: 40px;
    padding: 5rem;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
    font-weight: 700;
}

.form-group {
    margin: 1rem 0;
}

.form-control {
    width: 100%;
    padding: 1.5rem;
    border: 1px solid rgba(0, 0, 0, 0.10);
    border-radius: 0.5rem;
    font-size: 16px;
}

.title-container {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    flex-direction: column;
    word-wrap: break-word;
    margin-bottom: 1.5rem;
}

.subtitle {
    width: 70%;
    text-align: center;
}

.button-container {
    text-align: center;
    margin-top: 20px;
}

.btn {
    padding: 1rem 5rem;
    font-size: 18px;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn-primary {
    background-color: #5C99A3;
}

.btn-primary:hover {
  opacity: 0.5;
}

.account {
    margin-top: 0.5rem;
}

.link:hover {
    color: #007BFF;
}

.link {
    cursor: pointer;
    text-decoration: underline;
}
</style>
  