<template>
    <div class="card">
        <div class="card-header">
            <slot name="header">User Info</slot>
        </div>
        <div class="card-body">
            <div class="form-group">
                <label for="username">Username :</label>
                <input id="username" type="text" class="form-control" v-model="formData.username" />
            </div>
            <div class="form-group">
                <label for="email">E-mail :</label>
                <input id="email" type="email" class="form-control" v-model="formData.email" />
            </div>
            <div class="button-container">
                <button @click="submitForm" class="btn btn-primary">Update</button>
            </div>
        </div>
        <div class="card-footer">
            <button class="btn btn-secondary">Delete</button>
        </div>
    </div>
</template>
  
<script>
export default {
    name: 'User',
    data() {
        return {
            formData: {
                username:'',
                email: ''
            }
        }
    },
}
</script>
  
<style scoped>

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
    color: #fff;
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.btn-primary {
    background-color: #007BFF;
}

.btn-secondary {
    background-color: red;
}

</style>
  