// https://codepen.io/mschork/pen/gKQxyo?editors=0010

new Vue({
    delimiters: ['[[', ']]'],
    el: '#app',


    data() {
        return {
            companies: [],
            dropdown: { height: 0 },
            filters: { countries: {}, categories: {} },
            menus: { countries: false, categories: false }
        };
    },

    // COMPUTED
    computed: {
        activeMenu() {
            return Object.keys(this.menus).reduce(($$, set, i) => this.menus[set] ? i : $$, -1);
        },

        list() {
            let { countries, categories } = this.activeFilters;

            return this.companies.filter(({ country, keywords }) => {
                if (countries.length && !~countries.indexOf(country)) return false;
                return !categories.length || categories.every(cat => ~keywords.indexOf(cat));
            });
        },

        activeFilters() {
            let { countries, categories } = this.filters;

            return {
                countries: Object.keys(countries).filter(c => countries[c]),
                categories: Object.keys(categories).filter(c => categories[c])
            };

        }
    },

    // WATCH
    watch: {
        activeMenu(index, from) {
            if (index === from) return;

            this.$nextTick(() => {
                if (!this.$refs.menu || !this.$refs.menu[index]) {
                    this.dropdown.height = 0;
                } else {
                    this.dropdown.height = `${this.$refs.menu[index].clientHeight + 16}px`;
                }
            });
        }
    },

    // METHODS
    methods: {
        setFilter(filter, option) {
            if (filter === 'countries') {
                this.filters[filter][option] = !this.filters[filter][option];
            } else {
                setTimeout(() => {
                    this.clearFilter(filter, option, this.filters[filter][option]);
                }, 100);
            }
        },

        clearAllFilters() {
            Object.keys(this.filters).forEach(this.clearFilter);
        },

        setMenu(menu, active) {
            Object.keys(this.menus).forEach(tab => {
                this.menus[tab] = !active && tab === menu;
            });
        }
    },

    // FETCH JSON
    beforeMount() {
        fetch('index.json').
            then(response => response.json()).
            then(companies => {
                this.companies = companies;

                console.log(companies)

                companies.forEach(({ country, keywords }) => {
                    this.$set(this.filters.countries, country, false);

                    keywords.forEach(category => {
                        this.$set(this.filters.categories, category, false);
                    });
                });
            });
    }
});

