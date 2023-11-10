<template>
    <td><input v-model="user.username" class="items" /></td>
    <td><input v-model="user.email" class="items email" /></td>
    <td>
        <Dropdown v-model="user.role" :model-value="user.role" :options="roleOption" placeholder="Select a Role"
            class="w-full md:w-20rem" />
    </td>
    <td>
        <MultiSelect v-model="teamsSelected" display="chip" :options="teams" optionLabel="name" placeholder="Select Teams"
            :maxSelectedLabels="3" class="w-full md:w-20rem" />
    </td>
    <td class="actions">
        <div class="action" @click="showUserChart(user.id)">
            <svg xmlns="http://www.w3.org/2000/svg" width="29" height="22" viewBox="0 0 29 22" fill="none">
                <path
                    d="M26.2812 0H2.71875C1.21721 0 0 1.03901 0 2.32073V19.3394C0 20.6211 1.21721 21.6602 2.71875 21.6602H26.2812C27.7828 21.6602 29 20.6211 29 19.3394V2.32073C29 1.03901 27.7828 0 26.2812 0ZM12.6875 18.5658H3.625V6.18862H12.6875V18.5658ZM25.375 18.5658H16.3125V6.18862H25.375V18.5658Z"
                    fill="black" />
            </svg>
        </div>
        <div class="action" @click="deleteUser(user.id)">
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="26" viewBox="0 0 30 26" fill="none">
                <rect width="29.8096" height="25.1074" fill="white" />
                <path
                    d="M22.7764 3.45235H19.1899V2.78543C19.1899 1.60852 18.072 0.666992 16.6747 0.666992H13.0883C11.6909 0.666992 10.5731 1.60852 10.5731 2.78543V3.45235H6.98661C5.63586 3.45235 4.51801 4.39388 4.51801 5.53156V6.70847C4.51801 7.57153 5.12351 8.27768 6.00848 8.59152L6.75372 21.5768C6.84688 23.1852 8.43051 24.4406 10.3402 24.4406H19.3762C21.2859 24.4406 22.8695 23.1852 22.9627 21.5768L23.7545 8.55229C24.6395 8.23845 25.245 7.49307 25.245 6.66923V5.49232C25.245 4.39387 24.1271 3.45235 22.7764 3.45235ZM12.7156 2.78543C12.7156 2.58928 12.9019 2.43236 13.1348 2.43236H16.7213C16.9542 2.43236 17.1405 2.58928 17.1405 2.78543V3.45235H12.7622V2.78543H12.7156ZM6.66057 5.53156C6.66057 5.37463 6.8003 5.21771 7.03319 5.21771H22.7764C22.9627 5.21771 23.149 5.3354 23.149 5.53156V6.70847C23.149 6.86539 23.0093 7.02231 22.7764 7.02231H7.03319C6.84688 7.02231 6.66057 6.90462 6.66057 6.70847V5.53156ZM19.4228 22.6752H10.3868C9.59495 22.6752 8.94286 22.1652 8.89629 21.4591L8.19763 8.74844H21.6585L20.9599 21.4591C20.8667 22.126 20.2146 22.6752 19.4228 22.6752Z"
                    fill="#64748B" />
                <path
                    d="M14.9048 12.7109C14.3458 12.7109 13.8335 13.1032 13.8335 13.6132V18.5955C13.8335 19.0663 14.2993 19.4978 14.9048 19.4978C15.4637 19.4978 15.9761 19.1055 15.9761 18.5955V13.6132C15.9761 13.1032 15.4637 12.7109 14.9048 12.7109Z"
                    fill="#64748B" />
                <path
                    d="M18.631 13.4952C18.0255 13.4559 17.5597 13.809 17.5131 14.319L17.2337 17.7713C17.1871 18.242 17.6063 18.6736 18.2118 18.7128C18.2584 18.7128 18.2584 18.7128 18.3049 18.7128C18.8639 18.7128 19.3296 18.3597 19.3296 17.889L19.6091 14.4367C19.6091 13.9267 19.1899 13.5344 18.631 13.4952Z"
                    fill="#64748B" />
                <path
                    d="M11.132 13.4952C10.5731 13.5344 10.1073 13.9659 10.1539 14.4367L10.4799 17.889C10.5265 18.3597 10.9923 18.7128 11.5046 18.7128C11.5512 18.7128 11.5512 18.7128 11.5978 18.7128C12.1567 18.6736 12.6225 18.242 12.5759 17.7713L12.2499 14.319C12.2499 13.809 11.7375 13.4559 11.132 13.4952Z"
                    fill="#64748B" />
            </svg>
        </div>
        <div class="action" @click="sendUpdateUser(user.id)">
            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="29" viewBox="0 0 30 29" fill="none">
                <path
                    d="M23.2449 10.5177L22.8727 11.3056C22.7365 11.5977 22.446 11.7189 22.1873 11.6032C21.6517 11.3607 21.1615 11.0136 20.7303 10.5783C20.5215 10.369 20.467 9.9998 20.6032 9.71328L20.9754 8.92537C20.6622 8.48458 20.4171 7.97215 20.2537 7.41565H19.5047C19.2324 7.41565 18.9964 7.17873 18.951 6.84813C18.8602 6.18694 18.8557 5.4927 18.951 4.80396C18.9964 4.47336 19.2324 4.23093 19.5047 4.23093H20.2537C20.4171 3.67443 20.6622 3.162 20.9754 2.72121L20.6032 1.9333C20.467 1.64678 20.517 1.27762 20.7303 1.06824C21.1615 0.632957 21.6563 0.285833 22.1873 0.043397C22.446 -0.0723111 22.7365 0.0489069 22.8727 0.340932L23.2449 1.12885C23.7215 1.02416 24.2072 1.02416 24.6838 1.12885L25.056 0.340932C25.1922 0.0489069 25.4827 -0.0723111 25.7414 0.043397C26.277 0.285833 26.7672 0.632957 27.1984 1.06824C27.4072 1.27762 27.4617 1.64678 27.3255 1.9333L26.9533 2.72121C27.2665 3.162 27.5116 3.67443 27.675 4.23093H28.424C28.6963 4.23093 28.9324 4.46785 28.9777 4.79845C29.0685 5.45964 29.0731 6.15388 28.9777 6.84262C28.9324 7.17322 28.6963 7.41565 28.424 7.41565H27.675C27.5116 7.97215 27.2665 8.48458 26.9533 8.92537L27.3255 9.71328C27.4617 9.9998 27.4118 10.369 27.1984 10.5783C26.7672 11.0136 26.2725 11.3607 25.7414 11.6032C25.4827 11.7189 25.1922 11.5977 25.056 11.3056L24.6838 10.5177C24.2117 10.6224 23.7215 10.6224 23.2449 10.5177ZM22.7683 7.27791C24.5159 8.90884 26.5085 6.48999 25.1649 4.36867C23.4174 2.73223 21.4248 5.15659 22.7683 7.27791ZM17.5348 15.7577L19.0645 16.6833C19.5229 17.0029 19.7226 17.6806 19.5411 18.2867C19.1371 19.6201 18.3427 20.8433 17.6074 21.9122C17.2715 22.4026 16.6905 22.5238 16.2321 22.2042L14.9112 21.2786C14.185 22.0334 13.3407 22.634 12.4193 23.0252V24.8765C12.4193 25.5157 12.0425 26.0667 11.5251 26.1769C10.4085 26.4083 9.2374 26.4193 8.07994 26.1769C7.55795 26.0667 7.17213 25.5212 7.17213 24.8765V23.0252C6.2507 22.6285 5.40644 22.0334 4.68019 21.2786L3.35933 22.1987C2.90542 22.5183 2.31988 22.3971 1.98399 21.9067C1.24867 20.8378 0.472488 19.6146 0.068512 18.2867C-0.11305 17.6861 0.0866682 17.0084 0.545113 16.6833L2.05662 15.7577C1.87959 14.6061 1.87959 13.4215 2.05662 12.2644L0.545113 11.3332C0.0866682 11.0136 -0.117589 10.3359 0.068512 9.73532C0.472488 8.40193 1.24867 7.17873 1.98399 6.10981C2.31988 5.61942 2.90088 5.49821 3.35933 5.81778L4.68019 6.74344C5.40644 5.98859 6.2507 5.38801 7.17213 4.9968V3.13997C7.17213 2.50633 7.54433 1.95533 8.06179 1.84514C9.17839 1.61372 10.354 1.6027 11.5115 1.83963C12.0335 1.94983 12.4193 2.49531 12.4193 3.13997V4.99129C13.3407 5.38801 14.185 5.98308 14.9112 6.73793L16.2321 5.81227C16.686 5.4927 17.2715 5.61391 17.6074 6.1043C18.3427 7.17322 19.1144 8.39642 19.5184 9.72981C19.6999 10.3304 19.5229 11.0081 19.0645 11.3332L17.5348 12.2589C17.7118 13.4159 17.7118 14.6006 17.5348 15.7577ZM12.1969 16.9202C14.884 12.6776 10.8942 7.83441 7.39908 11.0963C4.71196 15.3389 8.70179 20.1821 12.1969 16.9202ZM23.2449 26.9868L22.8727 27.7748C22.7365 28.0668 22.446 28.188 22.1873 28.0723C21.6517 27.8299 21.1615 27.4827 20.7303 27.0475C20.5215 26.8381 20.467 26.4689 20.6032 26.1824L20.9754 25.3945C20.6622 24.9537 20.4171 24.4413 20.2537 23.8848H19.5047C19.2324 23.8848 18.9964 23.6478 18.951 23.3172C18.8602 22.6561 18.8557 21.9618 18.951 21.2731C18.9964 20.9425 19.2324 20.7 19.5047 20.7H20.2537C20.4171 20.1435 20.6622 19.6311 20.9754 19.1903L20.6032 18.4024C20.467 18.1159 20.517 17.7467 20.7303 17.5374C21.1615 17.1021 21.6563 16.7549 22.1873 16.5125C22.446 16.3968 22.7365 16.518 22.8727 16.81L23.2449 17.598C23.7215 17.4933 24.2072 17.4933 24.6838 17.598L25.056 16.81C25.1922 16.518 25.4827 16.3968 25.7414 16.5125C26.277 16.7549 26.7672 17.1021 27.1984 17.5374C27.4072 17.7467 27.4617 18.1159 27.3255 18.4024L26.9533 19.1903C27.2665 19.6311 27.5116 20.1435 27.675 20.7H28.424C28.6963 20.7 28.9324 20.937 28.9777 21.2676C29.0685 21.9287 29.0731 22.623 28.9777 23.3117C28.9324 23.6423 28.6963 23.8848 28.424 23.8848H27.675C27.5116 24.4413 27.2665 24.9537 26.9533 25.3945L27.3255 26.1824C27.4617 26.4689 27.4118 26.8381 27.1984 27.0475C26.7672 27.4827 26.2725 27.8299 25.7414 28.0723C25.4827 28.188 25.1922 28.0668 25.056 27.7748L24.6838 26.9868C24.2117 27.0915 23.7215 27.0915 23.2449 26.9868ZM22.7683 23.7415C24.5159 25.3724 26.5085 22.9536 25.1649 20.8323C23.4174 19.2013 21.4248 21.6202 22.7683 23.7415Z"
                    fill="black" />
            </svg>
        </div>
    </td>
</template>

<script>
import MultiSelect from 'primevue/multiselect'
import Dropdown from 'primevue/dropdown';
import { DELETE, PUT, POST } from '../api/axios';
import { ENDPOINTS } from '../api/endpoints';
import { createToast } from 'mosha-vue-toastify';
export default {
    name: 'AdminUser',
    components: {
        MultiSelect,
        Dropdown
    },
    props: {
        user: {
            type: Object,
        },
        teams: {
            type: Array,
        }
    },
    data() {
        return {
            token: localStorage.getItem('token'),
            teamsSelected: this.user.teams,
            initialTeams: [...this.user.teams],
            roleOption: ['user','admin' ,'superadmin' ]
        }
    },
    methods: {
        showUserChart(user_id) {
            this.$router.replace(`/usercharts/${user_id}`)
        },
        sendUpdateUser(user_id) {
            const user = {
                username: this.user.username,
                email: this.user.email,
                role: this.user.role
            }
            const data = {
                'user': user
            }
            const addedTeams = this.teamsSelected.filter(team => !this.initialTeams.includes(team));
            const removedTeams = this.initialTeams.filter(team => !this.teamsSelected.includes(team));
            this.initialTeams = [...this.teamsSelected];
            for (let i = 0; i < addedTeams.length; i++) {
                POST(ENDPOINTS.ADD_USER_TO_TEAM + user_id + '/teams/' + addedTeams[i].id, null, this.token)
                    .catch((error) => {
                        createToast({ title: 'Update Failed', description: `Failed to add ${addedTeams[i].name}` }, { type: 'danger', position: 'bottom-right' });
                        console.dir(error)
                    })
            }
            for (let i = 0; i < removedTeams.length; i++) {
                DELETE(ENDPOINTS.DELETE_USER_TO_TEAM + user_id + '/teams/' + removedTeams[i].id, this.token)
                    .catch((error) => { console.dir(error) })
            }
            PUT(ENDPOINTS.MODIFY_USER + user_id, data, this.token)
                .then((response) => {
                    createToast({ title: 'Update Success', description: `You have sucessfully updated the ${user.username} profile` }, { type: 'success', position: 'bottom-right' });
                    this.$emit('needrefresh')
                })
                .catch((error) => {
                    createToast({ title: 'Update Failed', description: 'Please try again' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        },
        deleteUser(user_id) {
            DELETE(ENDPOINTS.DELETE_USER + user_id, this.token)
                .then((response) => {
                    createToast({ title: 'Deletion Success', description: `You have sucessfully deleted the ${this.user.username} profile` }, { type: 'success', position: 'bottom-right' });
                    this.$emit('needrefresh')
                })
                .catch((error) => {
                    createToast({ title: 'Deletion Failed', description: 'Please try again' }, { type: 'danger', position: 'bottom-right' });
                    console.dir(error)
                })
        }
    },
}
</script>

<style scoped>
.teams-card {
    overflow-y: scroll;
    box-shadow: 0px 8px 13px -3px rgba(0, 0, 0, 0.07);
    border-radius: 4px;
    height: 90vh;
}

.teams-body {
    padding: 3rem;
}

.teams-card::-webkit-scrollbar {
    width: 3px;
}

/* Track */
.teams-card::-webkit-scrollbar-track {
    box-shadow: inset 0 0 5px grey;
    border-radius: 10px;
}

/* Handle */
.teams-card::-webkit-scrollbar-thumb {
    background: grey;
    border-radius: 10px;
}

/* Handle on hover */
.teams-card::-webkit-scrollbar-thumb:hover {
    background: #b30000;
}

.teams {
    display: flex;
    justify-content: space-between;
    font-size: 1.2rem;
    font-weight: bold;
}

table {
    width: 100%;
    border: none;
    font-size: 16px;
}

thead {
    background-color: #F7F9FC;
    border: none;
}

td {
    text-align: center;
    vertical-align: middle;
}

tr {
    text-align: center;
    height: 80px;
}

.actions {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    padding-top: 10px;
    height: 80px;
}

.items {
    border: none;
    text-align: center;
    width: 50%;
    padding: 8px;
    border-radius: 30px;
    font-family: Karla;
    font-size: 16px;
}

.email {
    font-weight: bold;
    background: rgba(33, 150, 83, 0.08);
}

.action {
    cursor: pointer;
}

.action:hover {
    opacity: 0.5;
}

.team-collapse {
    display: flex;
    align-items: center;
    gap: 3rem;
}

.rotation {
    transform: rotate(-180deg);
    transition: transform 0.3s;
}

button {
    background-color: transparent;
}
</style>