﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Master.Master" AutoEventWireup="true" CodeBehind="portfolio.aspx.cs" Inherits="Cryptfolio.Views.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Style" runat="server">
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/portfolio-style.css" />
    <link type="text/css" rel="stylesheet" href="../Public/Resources/CSS/vuetify.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Body" runat="server">
    <div class="wallet-content" id="app">
           <div class="wallet-inside-content">
               <div class="wallet-title">
                   <h2 style="margin:0; padding:10px;"><i class="material-icons" style="font-size:32px;top:2px;">account_balance_wallet</i>&nbsp;&nbsp;My Portfolio</h2>
               </div>
               <div class="wallet-option">
                   <v-app id="app3">
                       <v-dialog
                            v-model="createCoinDialog"
                            max-width="600px"
                       >
                           <v-form v-model="validCreate" ref="formCreate">
                                <v-card>
                                    <v-card-title>
                                    <span class="headline">Add Coin</span>
                                    </v-card-title>
                                    <v-card-text>
                                            <v-container grid-list-md>
                                                <v-layout wrap>
                                                <v-flex xs12>
                                                    <v-select
                                                        label="Coin Name"
                                                        autocomplete
                                                        :loading="loading"
                                                        cache-items
                                                        required
                                                        :items="coinList"
                                                        attach
                                                        :rules="createRules"
                                                        :search-input.sync="searchForCoin"
                                                        v-model="coinCreate.coin"
                                                        id="coinNameInput"
                                                        ></v-select>
                                                </v-flex>
                                                <v-flex xs12 sm6 md3>
                                                    <v-text-field label="Amount" v-model="coinCreate.amount" :rules="amountRules"></v-text-field>
                                                </v-flex>
                                                <v-flex xs12 sm6 md4>
                                                    <v-text-field label="Buy Price" v-model="coinCreate.buyPrice" :rules="priceRules"></v-text-field>
                                                </v-flex>
                                                <v-flex xs12 sm6 md4>
                                                    <v-menu
                                                        ref="menuCreate"
                                                        lazy
                                                        attach="createDatePicker"
                                                        :close-on-content-click="false"
                                                        v-model="menuCreate"
                                                        transition="scale-transition"
                                                        full-width
                                                        offset-y
                                                        :nudge-right="40"
                                                        max-width="290px"
                                                        min-width="290px"
                                                        :return-value.sync="coinCreate.buyDate"
                                                    >
                                                            <v-text-field slot="activator" label="Bought on" v-model="coinCreate.buyDate" readonly :rules="dateRules" id="createDate"></v-text-field>
                                                            <v-date-picker v-model="coinCreate.buyDate" no-title scrollable actions>
                                                            <template slot-scope="{ save, cancel }">
                                                                <v-card-actions>
                                                                    <v-spacer></v-spacer>
                                                                    <v-btn flat color="primary" @click="menuCreate = false">Cancel</v-btn>
                                                                    <v-btn flat color="primary" @click="$refs.menuCreate.save(coinCreate.buyDate)">OK</v-btn>
                                                                </v-card-actions>
                                                            </template>
                                                        </v-date-picker>
                                                </v-menu>
                                            </v-flex>
                                                           
                                            </v-layout>
                                        </v-container>
                                        </v-card-text>
                                        <v-card-actions>
                                        <v-spacer></v-spacer>
                                        <v-btn color="blue darken-1" flat @click.native="close">Cancel</v-btn>
                                        <v-btn color="blue darken-1" flat @click.native="create" :disabled="!validCreate">Create</v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-form>
                       </v-dialog>
                   </v-app>
                   <button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" style="margin:10px;" @click="createCoin()">
                      <i class="material-icons">add</i>&nbsp;Coin
                   </button>
               </div>
               <div class="wallet-summary">
                   <div class="acquisition-cost mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Acquisition Cost
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Acquisition cost here
                       </div>
                   </div>
                   <div class="profit-loss mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title ">
                           Profit/Loss
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Profit/Loss goes here
                       </div>
                   </div>
                   <div class="holdings mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Holdings
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Holdings go here
                       </div>
                   </div>
                   <div class="day-profit-loss mdl-card mdl-shadow--4dp">
                       <div class="mdl-card__title">
                           Realized Profit/Loss
                       </div>
                       <div class="mdl-card__supporting-text mdl-typography--text-left">
                           Profit/Loss goes here
                       </div>
                   </div>
               </div>
               <div class="outer-overview">
                   <div class="overview mdl-tabs mdl-js-tabs mdl-js-ripple-effect mdl-shadow--6dp">
                       <div class="mdl-tabs__tab-bar overview-tabs-bar">
                           <a href="#summary" class="mdl-tabs__tab is-active"><i class="material-icons" style="vertical-align:middle;">assignment</i>&nbsp;&nbsp;Overview</a>
                           <a href="#accounting" class="mdl-tabs__tab" id="newsTab"><i class="material-icons" style="vertical-align:middle;">attach_money</i>&nbsp;&nbsp;Accounting</a>
                       </div>
                       <div class="mdl-tabs__panel is-active overview-summary" id="summary">
                           <div class="mdl-grid" style="padding:0;">
                               <div class="mdl-cell mdl-cell--4-col wallet-change">

                                    <div class="stats-header">
                                        <span class="label-portfolio-stat">Portfolio Change</span>
                                        <div class="period-change value-portfolio-stat">NaN</div>
                                    </div>
                                    <div class="mdl-grid--no-spacing" style="text-align:left;">
                                        <div class="mdl-cell mdl-cell--6-col block-stat portfolio-min">
                                            <span class="label-portfolio-stat">Portfolio MIN</span>
                                            <span class="value-portfolio-stat">NaN</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat portfolio-max">
                                            <span class="label-portfolio-stat">Portfolio MAX</span>
                                            <span class="value-portfolio-stat">NaN</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat least-profitable">
                                            <span class="label-portfolio-stat">Least Profitable</span>
                                            <span class="value-portfolio-stat">NaN</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat most-profitable">
                                            <span class="label-portfolio-stat">Most Profitable</span>
                                            <span class="value-portfolio-stat">NaN</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat worst-crypto">
                                            <span class="label-portfolio-stat">Worst Crypto</span>
                                            <span class="value-portfolio-stat">NaN</span>
                                        </div>
                                        <div class="mdl-cell mdl-cell--6-col block-stat best-crypto">
                                            <span class="label-portfolio-stat">Best Crypto</span>
                                            <span class="value-portfolio-stat">NaN</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="mdl-cell mdl-cell--8-col chart">
                                    <div id="chart-portfolio">

                                    </div>
                                </div>
                           </div> 
                           
                       </div>
                       <div class="mdl-tabs__panel calculating-sales" id="accounting">
                           <div class="mdl-grid" style="padding:0;">
                               <div class="mdl-cel mdl-cell--4-col holdings-pie-chart" style="padding-top:20px; padding-left:10px;">
                                    <h4 style="font-size: 17px;
                                              color: #ff8e13;
                                              text-align:left;">Coins</h4>
                                    <div id="pie-chart" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>
                               </div>
                               <div class="mdl-cell mdl-cell--5-col-desktop income-statement" style="padding:20px; overflow-x:auto;">
                                   <h4 style="font-size: 17px;
                                              color: #ff8e13;
                                              text-align:left;">Income Statement</h4>
                                   <table class="mdl-data-table mdl-js-data-table" >
                                       <thead>
                                           <tr>
                                               <th>Item</th>
                                               <th>Amount</th>  
                                           </tr>
                                       </thead>
                                       <tbody>
                                           <tr>
                                               <td>Total Investment On Sold Positions</td>
                                               <td>Money here</td>
                                           </tr>
                                           <tr>
                                               <td>Total Revenue</td>
                                               <td>Money here</td>
                                           </tr>
                                           <tr>
                                               <td >Realized P/L</td>
                                               <td>Money here</td>
                                           </tr>
                                       </tbody>
                                   </table>
                               </div>
                               <div class="mdl-cell mdl-cell--3-col-desktop cashflow-statement" style="padding-top: 20px; ">
                                   <h4 style="font-size: 17px;
                                              color: #ff8e13;
                                              text-align:left;">Cashflow Statement</h4>
                                   <table class="mdl-data-table mdl-js-data-table" >
                                       <thead>
                                           <tr>
                                               <th>Item</th>
                                               <th>Amount</th>  
                                           </tr>
                                       </thead>
                                       <tbody>
                                           <tr>
                                               <td>Total Investment</td>
                                               <td>Money here</td>
                                           </tr>
                                           <tr>
                                               <td>Total Revenue</td>
                                               <td>Money here</td>
                                           </tr>
                                           <tr>
                                               <td>Net Cashflow</td>
                                               <td>Money here</td>
                                           </tr>
                                       </tbody>
                                   </table>
                               </div>
                           </div>
                       </div>
                   </div>
               </div>
               <div class="outer-detail-view">
                   <div class="detail-view mdl-tabs mdl-js-tabs mdl-js-ripple-effect">
                        <div class="mdl-tabs__tab-bar detail-tabs-bar">
                           <a href="#current" class="mdl-tabs__tab is-active"><i class="material-icons" style="vertical-align:middle;">timeline</i>&nbsp;&nbsp;Current</a>
                        </div>
                       <div class="mdl-tabs__panel is-active coin-current" id="current">
                           <%--Vuetify Data Tables--%>
                           <v-app id="inspire">
                               <v-dialog v-model="dialog" max-width="600px">
                                <v-tabs
                                  color="light-blue lighten-3"
                                  hide-slider
                                  centered 
                                >
                                  <v-tab href="#edit" @click="overFlow()">
                                      Edit
                                  </v-tab>
                                  <v-tab href="#sell" @click="overFlow()">
                                      Sell
                                  </v-tab>
                                 
                                  <v-tabs-items>
                                      
                                  <v-tab-item id="edit">
                                          <v-form v-model="validEdit" ref="formEdit">
                                                <v-card>
                                                  <v-card-title>
                                                    <span class="headline">Edit Coin</span>
                                                  </v-card-title>
                                                  <v-card-text>
                                                          <v-container grid-list-md>
                                                              <v-layout wrap>
                                                                <v-flex xs12>
                                                                  <v-text-field label="Coin Name" v-model="editedItem.coin" disabled></v-text-field>
                                                                </v-flex>
                                                                <v-flex xs12 sm6 md3>
                                                                  <v-text-field label="Amount" v-model="editedItem.amount" :rules="amountRules"></v-text-field>
                                                                </v-flex>
                                                                <v-flex xs12 sm6 md4>
                                                                  <v-text-field label="Buy Price" v-model="editedItem.buyPrice" :rules="priceRules"></v-text-field>
                                                                </v-flex>
                                                                <v-flex xs12 sm6 md4>
                                                                    <v-menu
                                                                      ref="menu"
                                                                      lazy
                                                                      attach="datePicker"
                                                                      :close-on-content-click="false"
                                                                      v-model="menu"
                                                                      transition="scale-transition"
                                                                      full-width
                                                                      offset-y
                                                                      :nudge-right="40"
                                                                      max-width="290px"
                                                                      min-width="290px"
                                                                      :return-value.sync="editedItem.buyDate"
                                                                    >
                                                                         <v-text-field @click.native="stopOverFlow()" slot="activator" label="Bought on" v-model="editedItem.buyDate" readonly :rules="dateRules" id="buyDate"></v-text-field>
                                                                          <v-date-picker v-model="editedItem.buyDate" no-title scrollable actions>
                                                                            <template slot-scope="{ save, cancel }">
                                                                                <v-card-actions>
                                                                                    <v-spacer></v-spacer>
                                                                                    <v-btn flat color="primary" @click="menu = false">Cancel</v-btn>
                                                                                    <v-btn flat color="primary" @click="$refs.menu.save(editedItem.buyDate)">OK</v-btn>
                                                                                </v-card-actions>
                                                                            </template>
                                                                        </v-date-picker>
                                                                </v-menu>
                                                            </v-flex>
                                                           
                                                          </v-layout>
                                                        </v-container>
                                                      </v-card-text>
                                                      <v-card-actions>
                                                        <v-spacer></v-spacer>
                                                        <v-btn color="blue darken-1" flat @click.native="close">Cancel</v-btn>
                                                        <v-btn color="blue darken-1" flat @click.native="update" :disabled="!validEdit">Update</v-btn>
                                                      </v-card-actions>
                                                    </v-card>
                                                </v-form>  
                                      </v-tab-item>
                                      <v-tab-item id="sell">
                                          <v-form v-model="validSell" ref="formSell">
                                                <v-card>
                                                      <v-card-title>
                                                        <span class="headline">Sell Coin</span>
                                                      </v-card-title>
                                                      <v-card-text>
                                                          <v-container grid-list-md>
                                                              <v-layout wrap>
                                                                  <v-flex xs12>
                                                                      <v-text-field label="Coin Name" v-model="sellItem.coin" disabled></v-text-field>
                                                                    </v-flex>
                                                                    <v-flex xs12 sm6 md3>
                                                                      <v-text-field label="Sell Amount" v-model="sellItem.sellAmount" :rules="sellAmountRules"></v-text-field>
                                                                    </v-flex>
                                                                    <v-flex xs12 sm6 md4>
                                                                      <v-text-field label="Sell Price" v-model="sellItem.price" :rules="priceRules"></v-text-field>
                                                                    </v-flex>
                                                                    
                                                                    <v-flex xs12 sm6 md4>
                                                                        <v-menu
                                                                          ref="sellMenu"
                                                                          lazy
                                                                          attach="sellDatePicker"
                                                                          :close-on-content-click="false"
                                                                          v-model="sellMenu"
                                                                          transition="scale-transition"
                                                                          full-width
                                                                          offset-y
                                                                          :nudge-right="40"
                                                                          max-width="290px"
                                                                          min-width="290px"
                                                                          :return-value.sync="sellItem.soldDate"
                                                                        >
                                                                             <v-text-field @click.native="stopOverFlow()" slot="activator" label="Sold on" v-model="sellItem.soldDate" readonly :rules="dateRules" id="sellDate"></v-text-field>
                                                                              <v-date-picker v-model="sellItem.soldDate" no-title scrollable actions>
                                                                                <template slot-scope="{ save, cancel }">
                                                                                    <v-card-actions>
                                                                                        <v-spacer></v-spacer>
                                                                                        <v-btn flat color="primary" @click="sellMenu = false">Cancel</v-btn>
                                                                                        <v-btn flat color="primary" @click="$refs.sellMenu.save(sellItem.soldDate)">OK</v-btn>
                                                                                    </v-card-actions>
                                                                                </template>
                                                                            </v-date-picker>
                                                                    </v-menu>
                                                                        </v-flex>
                                                              </v-layout>
                                                          </v-container>
                                                      </v-card-text>
                                                      <v-card-actions>
                                                        <v-spacer></v-spacer>
                                                        <v-btn color="blue darken-1" flat @click.native="close">Cancel</v-btn>
                                                        <v-btn color="blue darken-1" flat @click.native="sell" :disabled="!validSell">Sell</v-btn>
                                                      </v-card-actions>
                                                </v-card>
                                          </v-form>
                                      </v-tab-item>
                                      
                                  </v-tabs-items>
                                  
                                </v-tabs>
                                
                              </v-dialog>
                               <v-data-table
                                   
                                   class="detailTable"
                                   :headers="headers"
                                   :items="itemsToDisplay"
                                   :search="search"
                                   :pagination.sync="pagination"
                                   hide-actions
                                >
                                   <template slot="headerCell" slot-scope="props">
                                       <v-tooltip bottom>
                                           <span slot="activator">
                                               {{props.header.text}}
                                           </span>
                                           <span>
                                               {{props.header.text}}
                                           </span>
                                       </v-tooltip>
                                   </template>
                                   <template slot="items" slot-scope="props">
                                       <td>{{props.item.coin}}</td>
                                       <td class="text-xs-center">{{props.item.price}} USD</td>
                                       <td class="text-xs-right">{{props.item.totalValue}} USD</td>
                                       <td class="text-xs-right">{{props.item.profitLoss}} USD</td>
                                       <td class="text-xs-right">{{props.item.change}} %</td>
                                       <td class="justify-center layout px-0">
                                            <v-btn icon class="mx-0" @click="editItem(props.item)">
                                              <i class="material-icons" color="teal">mode_edit</i>
                                            </v-btn>
                                            <v-btn icon class="mx-0" @click="deleteItem(props.item)">
                                              <i class="material-icons" color="pink">delete</i>
                                            </v-btn>
                                      </td>
                                   </template>
                               </v-data-table>
                               <div class="text-xs-center">
                                   <v-pagination v-model="pagination.page" :length="pages" circle></v-pagination>
                               </div>
                           </v-app> 
                       </div>
                       
                   </div>
               </div>
           </div>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Script" runat="server">
    <script type="text/javascript">
        
        var coin_data_today = <%=JSON_COIN_data_today%>;
        console.log(coin_data_today);
        var coin_data = <%=JSON_COIN_data%>;
        console.log(coin_data);

        $("#test").on("click", function () {
            console.log(1);
            var bodyAjax = {
                type: "add_coin",
                coin: "BTC",
                amount: 10,
                date: "2017-13-05"
            };

            $.ajax({
                type: "POST",
                url: "portfolio.aspx",
                data: bodyAjax,
                success: function (data) {
                    console.log(data);
                },
                error: function (data) {
                    console.log(data);
                }
            });
        });
        var vm = new Vue({
            el: '#app',
            data: {
                active: null,
                validEdit: true,
                validSell: true,
                
                sellAmountRules: [
                    v => !!v || 'Field is required',
                    v => (v && !isNaN(v) && ~~v == v && v > 0) || 'Field has to be in correct format',
                    v => (v && v <= vm.sellItem.amount) || 'The amount must not exceed holdings'
                ],
                amountRules: [
                    v => !!v || 'Field is required',
                    v => (v && !isNaN(v) && ~~v == v && v > 0) || 'Field has to be in correct format'
                ],
                priceRules: [
                    v => !!v || 'Field is required',
                    v => (v && !isNaN(v) && v > 0) || 'Field has to be in correct format'
                ],
                dateRules: [
                    v => !!v || 'Field is required'
                ],
                sellMenu: false,
                menu: false,
                //Dialog for Creating Coins
                createCoinDialog: false,
                validCreate: true,
                menuCreate: false,
                loading: false,
                coinList: [],
                searchForCoin: null,
                coins: ["BTC", "ETH", "XRP", "BCH", "NEO", "LTC", "ADA", "EOS", "XLM", "VEN", "IOTA", "XMR", "TRX", "ETC", "LSK", "QTUM", "OMG", "XVG", "USDT", "XRB"],
                createRules: [
                    v => !!v || 'Field is required'
                ],
                //Edit/Sell Dialog
                dialog: false,
                search: '',
                searchSell: '',
                //For Current
                pagination: {},
                //For Sold
                pagination2: {},
                selected: [],
                headers: [
                    {
                        text: '#  Coin',
                        align: 'left',
                        value: 'coin'
                    },
                    {
                        text: 'Price',
                        align: 'center',
                        value: 'price'
                    },
                    {
                        text: 'Total Value',
                        align: 'right',
                        value: 'totalValue'
                    },
                    {
                        text: 'Profit/Loss',
                        align: 'right',
                        value: 'profitLoss'
                    },
                    {
                        text: 'Change',
                        align: 'right',
                        value: 'change'
                    },
                    { text: 'Actions', value: 'name', sortable: false }
                ],
                sellHeaders: [
                    {
                        text: '#  Coin',
                        align: 'left',
                        value: 'coin'
                    },
                    {
                        text: 'Price',
                        align: 'center',
                        value: 'price'
                    },
                    {
                        text: 'Total Value',
                        align: 'right',
                        value: 'totalValue'
                    },
                    {
                        text: 'Profit/Loss',
                        align: 'right',
                        value: 'profitLoss'
                    },
                    {
                        text: 'Change',
                        align: 'right',
                        value: 'change'
                    }
                ],
                items: [
                    {
                        coin: 'Bitcoin (BTC)',
                        price: 8589.55,
                        totalValue: '93.46k',
                        profitLoss: '-28.76k',
                        change: -23.53,
                        amount: 10,
                        buyPrice: 1000.00,
                        buyDate: '1997-03-06'
                    },
                    {
                       
                        coin: 'Bitcoin (BTC)',
                        price: 8589.55,
                        totalValue: '93.46k',
                        profitLoss: '-28.76k',
                        change: -23.53,
                        amount: 10,
                        buyPrice: 1000.00,
                        buyDate: '1997-03-06'
                    },
                    {
                        
                        coin: 'Bitcoin (BTC)',
                        price: 8589.55,
                        totalValue: '93.46k',
                        profitLoss: '-28.76k',
                        change: -23.53,
                        amount: 10,
                        buyPrice: 1000.00,
                        buyDate: '1997-03-06'
                    },
                    {
                       
                        coin: 'Bitcoin (BTC)',
                        price: 8589.55,
                        totalValue: '93.46k',
                        profitLoss: '-28.76k',
                        change: -23.53,
                        amount: 10,
                        buyPrice: 1000.00,
                        buyDate: '1997-03-06'
                    },
                    {
                        
                        coin: 'Bitcoin (BTC)',
                        price: 8589.55,
                        totalValue: '93.46k',
                        profitLoss: '-28.76k',
                        change: -23.53,
                        amount: 10,
                        buyPrice: 1000.00,
                        buyDate: '1997-03-06'
                    },
                    {
                        
                        coin: 'Bitcoin (BTC)',
                        price: 8589.55,
                        totalValue: '93.46k',
                        profitLoss: '-28.76k',
                        change: -23.53,
                        amount: 10,
                        buyPrice: 1000.00,
                        buyDate: '1997-03-06'
                    },

                ],
                soldItems: [],
                soldItemsToDisplay: [],
                itemsToDisplay: [],
                editedItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                },
                defaultItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                },
                //Dummy to hold value to sell
                sellItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: '',
                    sellAmount: 0,
                    soldDate: ''
                },
                defaultSellItem: {
                    coin: '',
                    price: 0,
                    totalValue: '0',
                    profitLoss: '0',
                    change: 0,
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: '',
                    sellAmount: 0,
                    soldDate: ''
                },
                //Dummy value for creating coin
                coinCreate: {
                    coin: '',
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                },
                coinCreateDefault: {
                    coin: '',
                    amount: 0,
                    buyPrice: 0.00,
                    buyDate: ''
                }
                
            },
            computed: {
                //For Current
                pages() {
                    if (this.pagination.rowsPerPage == null || this.pagination.totalItems == null) {
                        return 0;
                    }
                    return Math.ceil(this.pagination.totalItems / this.pagination.rowsPerPage)
                },
                //For Sold
                pages2() {
                    if (this.pagination2.rowsPerPage == null || this.pagination2.totalItems == null) {
                        return 0;
                    }
                    return Math.ceil(this.pagination2.totalItems / this.pagination2.rowsPerPage)
                },
                //For Edit
                datePicker() {
                    return document.getElementById('buyDate');
                },
                //For Sell
                sellDatePicker() {
                    return document.getElementById('sellDate');
                },
                //For Create
                createDatePicker() {
                    return document.getElementById('createDate');
                },
                attachCoinName() {
                    return document.getElementById('coinNameInput');
                }
            }, watch: {
                dialog(val) {
                    val || this.close()
                },
                searchForCoin(val) {
                    val && this.querySelections(val)
                }
            },

            created() {
                this.initialize();
            },

            methods: {
                populate(item) {
                    var foo = [];
                    foo["coin"] = item.coin;
                    foo["price"] = item.price;
                    foo["totalValue"] = item.totalValue;
                    foo["profitLoss"] = item.profitLoss;
                    foo["change"] = item.change;
                    return foo;
                },
                initialize() {
                    this.items.forEach((item, index) =>{
                        this.itemsToDisplay.push(this.populate(item));
                    });
                    this.soldItems.forEach((item, index) => {
                        this.soldItemsToDisplay.push(this.populate(item));
                    });
                },
                
                editItem(item) {
                    var today = new Date();
                    var date = today.getFullYear() + "-" + parseInt(today.getMonth() + 1) + "-" + today.getDate();
                    this.editedIndex = this.itemsToDisplay.indexOf(item)
                    this.editedItem = Object.assign({}, this.items[this.editedIndex])
                    this.sellItem = Object.assign({ sellAmount: this.editedItem.amount, soldDate:date }, this.items[this.editedIndex])
                    console.log(this.sellItem);
                    this.dialog = true
                },

                deleteItem(item) {
                    const index = this.itemsToDisplay.indexOf(item)
                    confirm('Are you sure you want to delete this item?') && this.itemsToDisplay.splice(index, 1)
                },
                
                close() {
                    this.dialog = false
                    this.createCoinDialog = false
                    setTimeout(() => {
                        this.editedItem = Object.assign({}, this.defaultItem)
                        this.sellItem = Object.assign({}, this.defaultSellItem)
                        this.coinCreate = Object.assign({}, this.coinCreateDefault)
                        this.editedIndex = -1
                    }, 300)
                   
                },

                update() {
                    //Implementing AJAX request for Update
                    
                },
                sell() {
                    //Implementing AJAX request for Sell

                },
                create() {
                    //Implementing AJAX request for Create

                },
                compare(a, b) {
                    return (
                        isFinite(a = this.convertToDateObject(a).valueOf()) &&
                            isFinite(b = this.convertToDateObject(b).valueOf()) ?
                            (a > b) - (a < b) :
                            NaN
                    )
                },
                convertToDateObject(dateString) {
                    return (
                        dateString.constructor === Date ? dateString :
                            dateString.constructor === Number ? new Date(dateString) :
                                dateString.constructor === String ? new Date(dateString) :
                                    typeof dateString === "object" ? new Date(dateString.year, dateString.month, dateString.date) :
                                        NaN
                    )
                },
                /**
                 * Custom Class to fix Tabs - overflow attribute with Date Picker
                 */
                stopOverFlow() {
                    var tabs = $('.tabs__items');
                    tabs.css({ 'overflow': 'visible' });
                },
                overFlow() {
                    var tabs = $('.tabs__items');
                    tabs.css({ 'overflow': 'hidden' });
                },
                //Create Coin
                createCoin() {
                    this.createCoinDialog = true;
                },
                querySelections(v) {
                    this.loading = true
                    setTimeout(() => {
                        this.coinList = this.coins.filter((e) => {
                            return (e || '').toLowerCase().indexOf((v || '').toLowerCase()) != -1
                        });
                        this.loading = false
                    },500);
                }
                
            }
        });
        function drawPortfolioChart() {
            var data =
                [

                    [1147651200000, 67.79],
                    [1147737600000, 64.98],
                    [1147824000000, 65.26],
                    [1147910400000, 63.18],
                    [1147996800000, 64.51],
                    [1148256000000, 63.38],
                    [1148342400000, 63.15],
                    [1148428800000, 63.34],
                    [1148515200000, 64.33],
                    [1148601600000, 63.55],
                    [1148947200000, 61.22],
                    [1149033600000, 59.77],

                    [1149120000000, 62.17],
                    [1149206400000, 61.66],
                    [1149465600000, 60.00],
                    [1149552000000, 59.72],
                    [1149638400000, 58.56],
                    [1149724800000, 60.76],
                    [1149811200000, 59.24],
                    [1150070400000, 57.00],
                    [1150156800000, 58.33],
                    [1150243200000, 57.61],
                    [1150329600000, 59.38],
                    [1150416000000, 57.56],
                    [1150675200000, 57.20],
                    [1150761600000, 57.47],
                    [1150848000000, 57.86],
                    [1150934400000, 59.58],
                    [1151020800000, 58.83],
                    [1151280000000, 58.99],
                    [1151366400000, 57.43],
                    [1151452800000, 56.02],
                    [1151539200000, 58.97],
                    [1151625600000, 57.27],

                    [1151884800000, 57.95],
                    [1152057600000, 57.00],
                    [1152144000000, 55.77],
                    [1152230400000, 55.40],
                    [1152489600000, 55.00],
                    [1152576000000, 55.65],
                    [1152662400000, 52.96],
                    [1152748800000, 52.25],
                    [1152835200000, 50.67],
                    [1153094400000, 52.37],
                    [1153180800000, 52.90],
                    [1153267200000, 54.10],
                    [1153353600000, 60.50],
                    [1153440000000, 60.72],
                    [1153699200000, 61.42],
                    [1153785600000, 61.93],
                    [1153872000000, 63.87],
                    [1153958400000, 63.40],
                    [1154044800000, 65.59],
                    [1154304000000, 67.96],

                    [1154390400000, 67.18],
                    [1154476800000, 68.16],
                    [1154563200000, 69.59],
                    [1154649600000, 68.30],
                    [1154908800000, 67.21],
                    [1154995200000, 64.78],
                    [1155081600000, 63.59],
                    [1155168000000, 64.07],
                    [1155254400000, 63.65],
                    [1155513600000, 63.94],
                    [1155600000000, 66.45],
                    [1155686400000, 67.98],
                    [1155772800000, 67.59],
                    [1155859200000, 67.91],
                    [1156118400000, 66.56],
                    [1156204800000, 67.62],
                    [1156291200000, 67.31],
                    [1156377600000, 67.81],
                    [1156464000000, 68.75],
                    [1156723200000, 66.98],
                    [1156809600000, 66.48],
                    [1156896000000, 66.96],
                    [1156982400000, 67.85],

                    [1157068800000, 68.38],
                    [1157414400000, 71.48],
                    [1157500800000, 70.03],
                    [1157587200000, 72.80],
                    [1157673600000, 72.52],
                    [1157932800000, 72.50],
                    [1158019200000, 72.63],
                    [1158105600000, 74.20],
                    [1158192000000, 74.17],
                    [1158278400000, 74.10],
                    [1158537600000, 73.89],
                    [1158624000000, 73.77],
                    [1158710400000, 75.26],
                    [1158796800000, 74.65],
                    [1158883200000, 73.00],
                    [1159142400000, 75.75],
                    [1159228800000, 77.61],
                    [1159315200000, 76.41],
                    [1159401600000, 77.01],
                    [1159488000000, 76.98],

                    [1159747200000, 74.86],
                    [1159833600000, 74.08],
                    [1159920000000, 75.38],
                    [1160006400000, 74.83],
                    [1160092800000, 74.22],
                    [1160352000000, 74.63],
                    [1160438400000, 73.81],
                    [1160524800000, 73.23],
                    [1160611200000, 75.26],
                    [1160697600000, 75.02],
                    [1160956800000, 75.40],
                    [1161043200000, 74.29],
                    [1161129600000, 74.53],
                    [1161216000000, 78.99],
                    [1161302400000, 79.95],
                    [1161561600000, 81.46],
                    [1161648000000, 81.05],
                    [1161734400000, 81.68],
                    [1161820800000, 82.19],
                    [1161907200000, 80.41],
                    [1162166400000, 80.42],
                    [1162252800000, 81.08],

                    [1162339200000, 79.16],
                    [1162425600000, 78.98],
                    [1162512000000, 78.29],
                    [1162771200000, 79.71],
                    [1162857600000, 80.51],
                    [1162944000000, 82.45],
                    [1163030400000, 83.34],
                    [1163116800000, 83.12],
                    [1163376000000, 84.35],
                    [1163462400000, 85.00],
                    [1163548800000, 84.05],
                    [1163635200000, 85.61],
                    [1163721600000, 85.85],
                    [1163980800000, 86.47],
                    [1164067200000, 88.60],
                    [1164153600000, 90.31],
                    [1164326400000, 91.63],
                    [1164585600000, 89.54],
                    [1164672000000, 91.81],
                    [1164758400000, 91.80],
                    [1164844800000, 91.66],

                    [1164931200000, 91.32],
                    [1165190400000, 91.12],
                    [1165276800000, 91.27],
                    [1165363200000, 89.83],
                    [1165449600000, 87.04],
                    [1165536000000, 88.26],
                    [1165795200000, 88.75],
                    [1165881600000, 86.14],
                    [1165968000000, 89.05],
                    [1166054400000, 88.55],
                    [1166140800000, 87.72],
                    [1166400000000, 85.47],
                    [1166486400000, 86.31],
                    [1166572800000, 84.76],
                    [1166659200000, 82.90],
                    [1166745600000, 82.20],
                    [1167091200000, 81.51],
                    [1167177600000, 81.52],
                    [1167264000000, 80.87],
                    [1167350400000, 84.84],

                    [1167782400000, 83.80],
                    [1167868800000, 85.66],
                    [1167955200000, 85.05],
                    [1168214400000, 85.47],
                    [1168300800000, 92.57],
                    [1168387200000, 97.00],
                    [1168473600000, 95.80],
                    [1168560000000, 94.62],
                    [1168905600000, 97.10],
                    [1168992000000, 94.95],
                    [1169078400000, 89.07],
                    [1169164800000, 88.50],
                    [1169424000000, 86.79],
                    [1169510400000, 85.70],
                    [1169596800000, 86.70],
                    [1169683200000, 86.25],
                    [1169769600000, 85.38],
                    [1170028800000, 85.94],
                    [1170115200000, 85.55],
                    [1170201600000, 85.73],

                    [1170288000000, 84.74],
                    [1170374400000, 84.75],
                    [1170633600000, 83.94],
                    [1170720000000, 84.15],
                    [1170806400000, 86.15],
                    [1170892800000, 86.18],
                    [1170979200000, 83.27],
                    [1171238400000, 84.88],
                    [1171324800000, 84.63],
                    [1171411200000, 85.30],
                    [1171497600000, 85.21],
                    [1171584000000, 84.83],
                    [1171929600000, 85.90],
                    [1172016000000, 89.20],
                    [1172102400000, 89.51],
                    [1172188800000, 89.07],
                    [1172448000000, 88.65],
                    [1172534400000, 83.93],
                    [1172620800000, 84.61],

                    [1172707200000, 87.06],
                    [1172793600000, 85.41],
                    [1173052800000, 86.32],
                    [1173139200000, 88.19],
                    [1173225600000, 87.72],
                    [1173312000000, 88.00],
                    [1173398400000, 87.97],
                    [1173657600000, 89.87],
                    [1173744000000, 88.40],
                    [1173830400000, 90.00],
                    [1173916800000, 89.57],
                    [1174003200000, 89.59],
                    [1174262400000, 91.13],
                    [1174348800000, 91.48],
                    [1174435200000, 93.87],
                    [1174521600000, 93.96],
                    [1174608000000, 93.52],
                    [1174867200000, 95.85],
                    [1174953600000, 95.46],
                    [1175040000000, 93.24],
                    [1175126400000, 93.75],
                    [1175212800000, 92.91],

                    [1175472000000, 93.65],
                    [1175558400000, 94.50],
                    [1175644800000, 94.27],
                    [1175731200000, 94.68],
                    [1176076800000, 93.65],
                    [1176163200000, 94.25],
                    [1176249600000, 92.59],
                    [1176336000000, 92.19],
                    [1176422400000, 90.24],
                    [1176681600000, 91.43],
                    [1176768000000, 90.35],
                    [1176854400000, 90.40],
                    [1176940800000, 90.27],
                    [1177027200000, 90.97],
                    [1177286400000, 93.51],
                    [1177372800000, 93.24],
                    [1177459200000, 95.35],
                    [1177545600000, 98.84],
                    [1177632000000, 99.92],
                    [1177891200000, 99.80],

                    [1177977600000, 99.47],
                    [1178064000000, 100.39],
                    [1178150400000, 100.40],
                    [1178236800000, 100.81],
                    [1178496000000, 103.92],
                    [1178582400000, 105.06],
                    [1178668800000, 106.88],
                    [1178755200000, 107.34],
                    [1178841600000, 108.74],
                    [1179100800000, 109.36],
                    [1179187200000, 107.52],
                    [1179273600000, 107.34],
                    [1179360000000, 109.44],
                    [1179446400000, 110.02],
                    [1179705600000, 111.98],
                    [1179792000000, 113.54],
                    [1179878400000, 112.89],
                    [1179964800000, 110.69],
                    [1180051200000, 113.62],
                    [1180396800000, 114.35],
                    [1180483200000, 118.77],
                    [1180569600000, 121.19],

                    [1180656000000, 118.40],
                    [1180915200000, 121.33],
                    [1181001600000, 122.67],
                    [1181088000000, 123.64],
                    [1181174400000, 124.07],
                    [1181260800000, 124.49],
                    [1181520000000, 120.19],
                    [1181606400000, 120.38],
                    [1181692800000, 117.50],
                    [1181779200000, 118.75],
                    [1181865600000, 120.50],
                    [1182124800000, 125.09],
                    [1182211200000, 123.66],
                    [1182297600000, 121.55],
                    [1182384000000, 123.90],
                    [1182470400000, 123.00],
                    [1182729600000, 122.34],
                    [1182816000000, 119.65],
                    [1182902400000, 121.89],
                    [1182988800000, 120.56],
                    [1183075200000, 122.04],

                    [1183334400000, 121.26],
                    [1183420800000, 127.17],
                    [1183593600000, 132.75],
                    [1183680000000, 132.30],
                    [1183939200000, 130.33],
                    [1184025600000, 132.35],
                    [1184112000000, 132.39],
                    [1184198400000, 134.07],
                    [1184284800000, 137.73],
                    [1184544000000, 138.10],
                    [1184630400000, 138.91],
                    [1184716800000, 138.12],
                    [1184803200000, 140.00],
                    [1184889600000, 143.75],
                    [1185148800000, 143.70],
                    [1185235200000, 134.89],
                    [1185321600000, 137.26],
                    [1185408000000, 146.00],
                    [1185494400000, 143.85],
                    [1185753600000, 141.43],
                    [1185840000000, 131.76],

                    [1185926400000, 135.00],
                    [1186012800000, 136.49],
                    [1186099200000, 131.85],
                    [1186358400000, 135.25],
                    [1186444800000, 135.03],
                    [1186531200000, 134.01],
                    [1186617600000, 126.39],
                    [1186704000000, 125.00],
                    [1186963200000, 127.79],
                    [1187049600000, 124.03],
                    [1187136000000, 119.90],
                    [1187222400000, 117.05],
                    [1187308800000, 122.06],
                    [1187568000000, 122.22],
                    [1187654400000, 127.57],
                    [1187740800000, 132.51],
                    [1187827200000, 131.07],
                    [1187913600000, 135.30],
                    [1188172800000, 132.25],
                    [1188259200000, 126.82],
                    [1188345600000, 134.08],
                    [1188432000000, 136.25],
                    [1188518400000, 138.48],

                    [1188864000000, 144.16],
                    [1188950400000, 136.76],
                    [1189036800000, 135.01],
                    [1189123200000, 131.77],
                    [1189382400000, 136.71],
                    [1189468800000, 135.49],
                    [1189555200000, 136.85],
                    [1189641600000, 137.20],
                    [1189728000000, 138.81],
                    [1189987200000, 138.41],
                    [1190073600000, 140.92],
                    [1190160000000, 140.77],
                    [1190246400000, 140.31],
                    [1190332800000, 144.15],
                    [1190592000000, 148.28],
                    [1190678400000, 153.18],
                    [1190764800000, 152.77],
                    [1190851200000, 154.50],
                    [1190937600000, 153.47],

                    [1191196800000, 156.34],
                    [1191283200000, 158.45],
                    [1191369600000, 157.92],
                    [1191456000000, 156.24],
                    [1191542400000, 161.45],
                    [1191801600000, 167.91],
                    [1191888000000, 167.86],
                    [1191974400000, 166.79],
                    [1192060800000, 162.23],
                    [1192147200000, 167.25],
                    [1192406400000, 166.98],
                    [1192492800000, 169.58],
                    [1192579200000, 172.75],
                    [1192665600000, 173.50],
                    [1192752000000, 170.42],
                    [1193011200000, 174.36],
                    [1193097600000, 186.16],
                    [1193184000000, 185.93],
                    [1193270400000, 182.78],
                    [1193356800000, 184.70],
                    [1193616000000, 185.09],
                    [1193702400000, 187.00],
                    [1193788800000, 189.95],

                    [1193875200000, 187.44],
                    [1193961600000, 187.87],
                    [1194220800000, 186.18],
                    [1194307200000, 191.79],
                    [1194393600000, 186.30],
                    [1194480000000, 175.47],
                    [1194566400000, 165.37],
                    [1194825600000, 153.76],
                    [1194912000000, 169.96],
                    [1194998400000, 166.11],
                    [1195084800000, 164.30],
                    [1195171200000, 166.39],
                    [1195430400000, 163.95],
                    [1195516800000, 168.85],
                    [1195603200000, 168.46],
                    [1195776000000, 171.54],
                    [1196035200000, 172.54],
                    [1196121600000, 174.81],
                    [1196208000000, 180.22],
                    [1196294400000, 184.29],
                    [1196380800000, 182.22],

                    [1196640000000, 178.86],
                    [1196726400000, 179.81],
                    [1196812800000, 185.50],
                    [1196899200000, 189.95],
                    [1196985600000, 194.30],
                    [1197244800000, 194.21],
                    [1197331200000, 188.54],
                    [1197417600000, 190.86],
                    [1197504000000, 191.83],
                    [1197590400000, 190.39],
                    [1197849600000, 184.40],
                    [1197936000000, 182.98],
                    [1198022400000, 183.12],
                    [1198108800000, 187.21],
                    [1198195200000, 193.91],
                    [1198454400000, 198.80],
                    [1198627200000, 198.95],
                    [1198713600000, 198.57],
                    [1198800000000, 199.83],
                    [1199059200000, 198.08],

                    [1199232000000, 194.84],
                    [1199318400000, 194.93],
                    [1199404800000, 180.05],
                    [1199664000000, 177.64],
                    [1199750400000, 171.25],
                    [1199836800000, 179.40],
                    [1199923200000, 178.02],
                    [1200009600000, 172.69],
                    [1200268800000, 178.78],
                    [1200355200000, 169.04],
                    [1200441600000, 159.64],
                    [1200528000000, 160.89],
                    [1200614400000, 161.36],
                    [1200960000000, 155.64],
                    [1201046400000, 139.07],
                    [1201132800000, 135.60],
                    [1201219200000, 130.01],
                    [1201478400000, 130.01],
                    [1201564800000, 131.54],
                    [1201651200000, 132.18],
                    [1201737600000, 135.36],

                    [1201824000000, 133.75],
                    [1202083200000, 131.65],
                    [1202169600000, 129.36],
                    [1202256000000, 122.00],
                    [1202342400000, 121.24],
                    [1202428800000, 125.48],
                    [1202688000000, 129.45],
                    [1202774400000, 124.86],
                    [1202860800000, 129.40],
                    [1202947200000, 127.46],
                    [1203033600000, 124.63],
                    [1203379200000, 122.18],
                    [1203465600000, 123.82],
                    [1203552000000, 121.54],
                    [1203638400000, 119.46],
                    [1203897600000, 119.74],
                    [1203984000000, 119.15],
                    [1204070400000, 122.96],
                    [1204156800000, 129.91],
                    [1204243200000, 125.02],

                    [1204502400000, 121.73],
                    [1204588800000, 124.62],
                    [1204675200000, 124.49],
                    [1204761600000, 120.93],
                    [1204848000000, 122.25],
                    [1205107200000, 119.69],
                    [1205193600000, 127.35],
                    [1205280000000, 126.03],
                    [1205366400000, 127.94],
                    [1205452800000, 126.61],
                    [1205712000000, 126.73],
                    [1205798400000, 132.82],
                    [1205884800000, 129.67],
                    [1205971200000, 133.27],
                    [1206316800000, 139.53],
                    [1206403200000, 140.98],
                    [1206489600000, 145.06],
                    [1206576000000, 140.25],
                    [1206662400000, 143.01],
                    [1206921600000, 143.50],

                    [1207008000000, 149.53],
                    [1207094400000, 147.49],
                    [1207180800000, 151.61],
                    [1207267200000, 153.08],
                    [1207526400000, 155.89],
                    [1207612800000, 152.84],
                    [1207699200000, 151.44],
                    [1207785600000, 154.55],
                    [1207872000000, 147.14],
                    [1208131200000, 147.78],
                    [1208217600000, 148.38],
                    [1208304000000, 153.70],
                    [1208390400000, 154.49],
                    [1208476800000, 161.04],
                    [1208736000000, 168.16],
                    [1208822400000, 160.20],
                    [1208908800000, 162.89],
                    [1208995200000, 168.94],
                    [1209081600000, 169.73],
                    [1209340800000, 172.24],
                    [1209427200000, 175.05],
                    [1209513600000, 173.95],

                    [1209600000000, 180.00],
                    [1209686400000, 180.94],
                    [1209945600000, 184.73],
                    [1210032000000, 186.66],
                    [1210118400000, 182.59],
                    [1210204800000, 185.06],
                    [1210291200000, 183.45],
                    [1210550400000, 188.16],
                    [1210636800000, 189.96],
                    [1210723200000, 186.26],
                    [1210809600000, 189.73],
                    [1210896000000, 187.62],
                    [1211155200000, 183.60],
                    [1211241600000, 185.90],
                    [1211328000000, 178.19],
                    [1211414400000, 177.05],
                    [1211500800000, 181.17],
                    [1211846400000, 186.43],
                    [1211932800000, 187.01],
                    [1212019200000, 186.69],
                    [1212105600000, 188.75],

                    [1212364800000, 186.10],
                    [1212451200000, 185.37],
                    [1212537600000, 185.19],
                    [1212624000000, 189.43],
                    [1212710400000, 185.64],
                    [1212969600000, 181.61],
                    [1213056000000, 185.64],
                    [1213142400000, 180.81],
                    [1213228800000, 173.26],
                    [1213315200000, 172.37],
                    [1213574400000, 176.84],
                    [1213660800000, 181.43],
                    [1213747200000, 178.75],
                    [1213833600000, 180.90],
                    [1213920000000, 175.27],
                    [1214179200000, 173.16],
                    [1214265600000, 173.25],
                    [1214352000000, 177.39],
                    [1214438400000, 168.26],
                    [1214524800000, 170.09],
                    [1214784000000, 167.44],

                    [1214870400000, 174.68],
                    [1214956800000, 168.18],
                    [1215043200000, 170.12],
                    [1215388800000, 175.16],
                    [1215475200000, 179.55],
                    [1215561600000, 174.25],
                    [1215648000000, 176.63],
                    [1215734400000, 172.58],
                    [1215993600000, 173.88],
                    [1216080000000, 169.64],
                    [1216166400000, 172.81],
                    [1216252800000, 171.81],
                    [1216339200000, 165.15],
                    [1216598400000, 166.29],
                    [1216684800000, 162.02],
                    [1216771200000, 166.26],
                    [1216857600000, 159.03],
                    [1216944000000, 162.12],
                    [1217203200000, 154.40],
                    [1217289600000, 157.08],
                    [1217376000000, 159.88],
                    [1217462400000, 158.95],

                    [1217548800000, 156.66],
                    [1217808000000, 153.23],
                    [1217894400000, 160.64],
                    [1217980800000, 164.19],
                    [1218067200000, 163.57],
                    [1218153600000, 169.55],
                    [1218412800000, 173.56],
                    [1218499200000, 176.73],
                    [1218585600000, 179.30],
                    [1218672000000, 179.32],
                    [1218758400000, 175.74],
                    [1219017600000, 175.39],
                    [1219104000000, 173.53],
                    [1219190400000, 175.84],
                    [1219276800000, 174.29],
                    [1219363200000, 176.79],
                    [1219622400000, 172.55],
                    [1219708800000, 173.64],
                    [1219795200000, 174.67],
                    [1219881600000, 173.74],
                    [1219968000000, 169.53],

                    [1220313600000, 166.19],
                    [1220400000000, 166.96],
                    [1220486400000, 161.22],
                    [1220572800000, 160.18],
                    [1220832000000, 157.92],
                    [1220918400000, 151.68],
                    [1221004800000, 151.61],
                    [1221091200000, 152.65],
                    [1221177600000, 148.94],
                    [1221436800000, 140.36],
                    [1221523200000, 139.88],
                    [1221609600000, 127.83],
                    [1221696000000, 134.09],
                    [1221782400000, 140.91],
                    [1222041600000, 131.05],
                    [1222128000000, 126.84],
                    [1222214400000, 128.71],
                    [1222300800000, 131.93],
                    [1222387200000, 128.24],
                    [1222646400000, 105.26],
                    [1222732800000, 113.66],

                    [1222819200000, 109.12],
                    [1222905600000, 100.10],
                    [1222992000000, 97.07],
                    [1223251200000, 98.14],
                    [1223337600000, 89.16],
                    [1223424000000, 89.79],
                    [1223510400000, 88.74],
                    [1223596800000, 96.80],
                    [1223856000000, 110.26],
                    [1223942400000, 104.08],
                    [1224028800000, 97.95],
                    [1224115200000, 101.89],
                    [1224201600000, 97.40],
                    [1224460800000, 98.44],
                    [1224547200000, 91.49],
                    [1224633600000, 96.87],
                    [1224720000000, 98.23],
                    [1224806400000, 96.38],
                    [1225065600000, 92.09],
                    [1225152000000, 99.91],
                    [1225238400000, 104.55],
                    [1225324800000, 111.04],
                    [1225411200000, 107.59],

                    [1225670400000, 106.96],
                    [1225756800000, 110.99],
                    [1225843200000, 103.30],
                    [1225929600000, 99.10],
                    [1226016000000, 98.24],
                    [1226275200000, 95.88],
                    [1226361600000, 94.77],
                    [1226448000000, 90.12],
                    [1226534400000, 96.44],
                    [1226620800000, 90.24],
                    [1226880000000, 88.14],
                    [1226966400000, 89.91],
                    [1227052800000, 86.29],
                    [1227139200000, 80.49],
                    [1227225600000, 82.58],
                    [1227484800000, 92.95],
                    [1227571200000, 90.80],
                    [1227657600000, 95.00],
                    [1227744000000, 95.00],
                    [1227830400000, 92.67],

                    [1228089600000, 88.93],
                    [1228176000000, 92.47],
                    [1228262400000, 95.90],
                    [1228348800000, 91.41],
                    [1228435200000, 94.00],
                    [1228694400000, 99.72],
                    [1228780800000, 100.06],
                    [1228867200000, 98.21],
                    [1228953600000, 95.00],
                    [1229040000000, 98.27],
                    [1229299200000, 94.75],
                    [1229385600000, 95.43],
                    [1229472000000, 89.16],
                    [1229558400000, 89.43],
                    [1229644800000, 90.00],
                    [1229904000000, 85.74],
                    [1229990400000, 86.38],
                    [1230076800000, 85.04],
                    [1230163200000, 85.04],
                    [1230249600000, 85.81],
                    [1230508800000, 86.61],
                    [1230595200000, 86.29],
                    [1230681600000, 85.35],

                    [1230768000000, 85.35],
                    [1230854400000, 90.75],
                    [1231113600000, 94.58],
                    [1231200000000, 93.02],
                    [1231286400000, 91.01],
                    [1231372800000, 92.70],
                    [1231459200000, 90.58],
                    [1231718400000, 88.66],
                    [1231804800000, 87.71],
                    [1231891200000, 85.33],
                    [1231977600000, 83.38],
                    [1232064000000, 82.33],
                    [1232409600000, 78.20],
                    [1232496000000, 82.83],
                    [1232582400000, 88.36],
                    [1232668800000, 88.36],
                    [1232928000000, 89.64],
                    [1233014400000, 90.73],
                    [1233100800000, 94.20],
                    [1233187200000, 93.00],
                    [1233273600000, 90.13],

                    [1233532800000, 91.51],
                    [1233619200000, 92.98],
                    [1233705600000, 93.55],
                    [1233792000000, 96.46],
                    [1233878400000, 99.72],
                    [1234137600000, 102.51],
                    [1234224000000, 97.83],
                    [1234310400000, 96.82],
                    [1234396800000, 99.27],
                    [1234483200000, 99.16],
                    [1234828800000, 94.53],
                    [1234915200000, 94.37],
                    [1235001600000, 90.64],
                    [1235088000000, 91.20],
                    [1235347200000, 86.95],
                    [1235433600000, 90.25],
                    [1235520000000, 91.16],
                    [1235606400000, 89.19],
                    [1235692800000, 89.31],

                    [1235952000000, 87.94],
                    [1236038400000, 88.37],
                    [1236124800000, 91.17],
                    [1236211200000, 88.84],
                    [1236297600000, 85.30],
                    [1236556800000, 83.11],
                    [1236643200000, 88.63],
                    [1236729600000, 92.68],
                    [1236816000000, 96.35],
                    [1236902400000, 95.93],
                    [1237161600000, 95.42],
                    [1237248000000, 99.66],
                    [1237334400000, 101.52],
                    [1237420800000, 101.62],
                    [1237507200000, 101.59],
                    [1237766400000, 107.66],
                    [1237852800000, 106.50],
                    [1237939200000, 106.49],
                    [1238025600000, 109.87],
                    [1238112000000, 106.85],
                    [1238371200000, 104.49],
                    [1238457600000, 105.12],

                    [1238544000000, 108.69],
                    [1238630400000, 112.71],
                    [1238716800000, 115.99],
                    [1238976000000, 118.45],
                    [1239062400000, 115.00],
                    [1239148800000, 116.32],
                    [1239235200000, 119.57],
                    [1239321600000, 119.57],
                    [1239580800000, 120.22],
                    [1239667200000, 118.31],
                    [1239753600000, 117.64],
                    [1239840000000, 121.45],
                    [1239926400000, 123.42],
                    [1240185600000, 120.50],
                    [1240272000000, 121.76],
                    [1240358400000, 121.51],
                    [1240444800000, 125.40],
                    [1240531200000, 123.90],
                    [1240790400000, 124.73],
                    [1240876800000, 123.90],
                    [1240963200000, 125.14],
                    [1241049600000, 125.83],

                    [1241136000000, 127.24],
                    [1241395200000, 132.07],
                    [1241481600000, 132.71],
                    [1241568000000, 132.50],
                    [1241654400000, 129.06],
                    [1241740800000, 129.19],
                    [1242000000000, 129.57],
                    [1242086400000, 124.42],
                    [1242172800000, 119.49],
                    [1242259200000, 122.95],
                    [1242345600000, 122.42],
                    [1242604800000, 126.65],
                    [1242691200000, 127.45],
                    [1242777600000, 125.87],
                    [1242864000000, 124.18],
                    [1242950400000, 122.50],
                    [1243296000000, 130.78],
                    [1243382400000, 133.05],
                    [1243468800000, 135.07],
                    [1243555200000, 135.81],

                    [1243814400000, 139.35],
                    [1243900800000, 139.49],
                    [1243987200000, 140.95],
                    [1244073600000, 143.74],
                    [1244160000000, 144.67],
                    [1244419200000, 143.85],
                    [1244505600000, 142.72],
                    [1244592000000, 140.25],
                    [1244678400000, 139.95],
                    [1244764800000, 136.97],
                    [1245024000000, 136.09],
                    [1245110400000, 136.35],
                    [1245196800000, 135.58],
                    [1245283200000, 135.88],
                    [1245369600000, 139.48],
                    [1245628800000, 137.37],
                    [1245715200000, 134.01],
                    [1245801600000, 136.22],
                    [1245888000000, 139.86],
                    [1245974400000, 142.44],
                    [1246233600000, 141.97],
                    [1246320000000, 142.43],

                    [1246406400000, 142.83],
                    [1246492800000, 140.02],
                    [1246579200000, 140.02],
                    [1246838400000, 138.61],
                    [1246924800000, 135.40],
                    [1247011200000, 137.22],
                    [1247097600000, 136.36],
                    [1247184000000, 138.52],
                    [1247443200000, 142.34],
                    [1247529600000, 142.27],
                    [1247616000000, 146.88],
                    [1247702400000, 147.52],
                    [1247788800000, 151.75],
                    [1248048000000, 152.91],
                    [1248134400000, 151.51],
                    [1248220800000, 156.74],
                    [1248307200000, 157.82],
                    [1248393600000, 159.99],
                    [1248652800000, 160.10],
                    [1248739200000, 160.00],
                    [1248825600000, 160.03],
                    [1248912000000, 162.79],
                    [1248998400000, 163.39],

                    [1249257600000, 166.43],
                    [1249344000000, 165.55],
                    [1249430400000, 165.11],
                    [1249516800000, 163.91],
                    [1249603200000, 165.51],
                    [1249862400000, 164.72],
                    [1249948800000, 162.83],
                    [1250035200000, 165.31],
                    [1250121600000, 168.42],
                    [1250208000000, 166.78],
                    [1250467200000, 159.59],
                    [1250553600000, 164.00],
                    [1250640000000, 164.60],
                    [1250726400000, 166.33],
                    [1250812800000, 169.22],
                    [1251072000000, 169.06],
                    [1251158400000, 169.40],
                    [1251244800000, 167.41],
                    [1251331200000, 169.45],
                    [1251417600000, 170.05],
                    [1251676800000, 168.21],

                    [1251763200000, 165.30],
                    [1251849600000, 165.18],
                    [1251936000000, 166.55],
                    [1252022400000, 170.31],
                    [1252368000000, 172.93],
                    [1252454400000, 171.14],
                    [1252540800000, 172.56],
                    [1252627200000, 172.16],
                    [1252886400000, 173.72],
                    [1252972800000, 175.16],
                    [1253059200000, 181.87],
                    [1253145600000, 184.55],
                    [1253232000000, 185.02],
                    [1253491200000, 184.02],
                    [1253577600000, 184.48],
                    [1253664000000, 185.50],
                    [1253750400000, 183.82],
                    [1253836800000, 182.37],
                    [1254096000000, 186.15],
                    [1254182400000, 185.38],
                    [1254268800000, 185.35],

                    [1254355200000, 180.86],
                    [1254441600000, 184.90],
                    [1254700800000, 186.02],
                    [1254787200000, 190.01],
                    [1254873600000, 190.25],
                    [1254960000000, 189.27],
                    [1255046400000, 190.47],
                    [1255305600000, 190.81],
                    [1255392000000, 190.02],
                    [1255478400000, 191.29],
                    [1255564800000, 190.56],
                    [1255651200000, 188.05],
                    [1255910400000, 189.86],
                    [1255996800000, 198.76],
                    [1256083200000, 204.92],
                    [1256169600000, 205.20],
                    [1256256000000, 203.94],
                    [1256515200000, 202.48],
                    [1256601600000, 197.37],
                    [1256688000000, 192.40],
                    [1256774400000, 196.35],
                    [1256860800000, 188.50],

                    [1257120000000, 189.31],
                    [1257206400000, 188.75],
                    [1257292800000, 190.81],
                    [1257379200000, 194.03],
                    [1257465600000, 194.34],
                    [1257724800000, 201.46],
                    [1257811200000, 202.98],
                    [1257897600000, 203.25],
                    [1257984000000, 201.99],
                    [1258070400000, 204.45],
                    [1258329600000, 206.63],
                    [1258416000000, 207.00],
                    [1258502400000, 205.96],
                    [1258588800000, 200.51],
                    [1258675200000, 199.92],
                    [1258934400000, 205.88],
                    [1259020800000, 204.44],
                    [1259107200000, 204.19],
                    [1259193600000, 204.19],
                    [1259280000000, 200.59],
                    [1259539200000, 199.91],

                    [1259625600000, 196.97],
                    [1259712000000, 196.23],
                    [1259798400000, 196.48],
                    [1259884800000, 193.32],
                    [1260144000000, 188.95],
                    [1260230400000, 189.87],
                    [1260316800000, 197.80],
                    [1260403200000, 196.43],
                    [1260489600000, 194.67],
                    [1260748800000, 196.98],
                    [1260835200000, 194.17],
                    [1260921600000, 195.03],
                    [1261008000000, 191.86],
                    [1261094400000, 195.43],
                    [1261353600000, 198.23],
                    [1261440000000, 200.36],
                    [1261526400000, 202.10],
                    [1261612800000, 209.04],
                    [1261699200000, 209.04],
                    [1261958400000, 211.61],
                    [1262044800000, 209.10],
                    [1262131200000, 211.64],
                    [1262217600000, 210.73],

                    [1262304000000, 210.73],
                    [1262563200000, 214.01],
                    [1262649600000, 214.38],
                    [1262736000000, 210.97],
                    [1262822400000, 210.58],
                    [1262908800000, 211.98],
                    [1263168000000, 210.11],
                    [1263254400000, 207.72],
                    [1263340800000, 210.65],
                    [1263427200000, 209.43],
                    [1263513600000, 205.93],
                    [1263772800000, 205.93],
                    [1263859200000, 215.04],
                    [1263945600000, 211.72],
                    [1264032000000, 208.07],
                    [1264118400000, 197.75],
                    [1264377600000, 203.08],
                    [1264464000000, 205.94],
                    [1264550400000, 207.88],
                    [1264636800000, 199.29],
                    [1264723200000, 192.06],

                    [1264982400000, 194.73],
                    [1265068800000, 195.86],
                    [1265155200000, 199.23],
                    [1265241600000, 192.05],
                    [1265328000000, 195.46],
                    [1265587200000, 194.12],
                    [1265673600000, 196.19],
                    [1265760000000, 195.12],
                    [1265846400000, 198.67],
                    [1265932800000, 200.38],
                    [1266192000000, 200.38],
                    [1266278400000, 203.40],
                    [1266364800000, 202.55],
                    [1266451200000, 202.93],
                    [1266537600000, 201.67],
                    [1266796800000, 200.42],
                    [1266883200000, 197.06],
                    [1266969600000, 200.66],
                    [1267056000000, 202.00],
                    [1267142400000, 204.62],

                    [1267401600000, 208.99],
                    [1267488000000, 208.85],
                    [1267574400000, 209.33],
                    [1267660800000, 210.71],
                    [1267747200000, 218.95],
                    [1268006400000, 219.08],
                    [1268092800000, 223.02],
                    [1268179200000, 224.84],
                    [1268265600000, 225.50],
                    [1268352000000, 226.60],
                    [1268611200000, 223.84],
                    [1268697600000, 224.45],
                    [1268784000000, 224.12],
                    [1268870400000, 224.65],
                    [1268956800000, 222.25],
                    [1269216000000, 224.75],
                    [1269302400000, 228.36],
                    [1269388800000, 229.37],
                    [1269475200000, 226.65],
                    [1269561600000, 230.90],
                    [1269820800000, 232.39],
                    [1269907200000, 235.84],
                    [1269993600000, 235.00],

                    [1270080000000, 235.97],
                    [1270166400000, 235.97],
                    [1270425600000, 238.49],
                    [1270512000000, 239.54],
                    [1270598400000, 240.60],
                    [1270684800000, 239.95],
                    [1270771200000, 241.79],
                    [1271030400000, 242.29],
                    [1271116800000, 242.43],
                    [1271203200000, 245.69],
                    [1271289600000, 248.92],
                    [1271376000000, 247.40],
                    [1271635200000, 247.07],
                    [1271721600000, 244.59],
                    [1271808000000, 259.22],
                    [1271894400000, 266.47],
                    [1271980800000, 270.83],
                    [1272240000000, 269.50],
                    [1272326400000, 262.04],
                    [1272412800000, 261.60],
                    [1272499200000, 268.64],
                    [1272585600000, 261.09],

                    [1272844800000, 266.35],
                    [1272931200000, 258.68],
                    [1273017600000, 255.98],
                    [1273104000000, 246.25],
                    [1273190400000, 235.86],
                    [1273449600000, 253.99],
                    [1273536000000, 256.52],
                    [1273622400000, 262.09],
                    [1273708800000, 258.36],
                    [1273795200000, 253.82],
                    [1274054400000, 254.22],
                    [1274140800000, 252.36],
                    [1274227200000, 248.34],
                    [1274313600000, 237.76],
                    [1274400000000, 242.32],
                    [1274659200000, 246.76],
                    [1274745600000, 245.22],
                    [1274832000000, 244.11],
                    [1274918400000, 253.35],
                    [1275004800000, 256.88],
                    [1275264000000, 256.88],

                    [1275350400000, 260.83],
                    [1275436800000, 263.95],
                    [1275523200000, 263.12],
                    [1275609600000, 255.96],
                    [1275868800000, 250.94],
                    [1275955200000, 249.33],
                    [1276041600000, 243.20],
                    [1276128000000, 250.51],
                    [1276214400000, 253.51],
                    [1276473600000, 254.28],
                    [1276560000000, 259.69],
                    [1276646400000, 267.25],
                    [1276732800000, 271.87],
                    [1276819200000, 274.07],
                    [1277078400000, 270.17],
                    [1277164800000, 273.85],
                    [1277251200000, 270.97],
                    [1277337600000, 269.00],
                    [1277424000000, 266.70],
                    [1277683200000, 268.30],
                    [1277769600000, 256.17],
                    [1277856000000, 251.53],

                    [1277942400000, 248.48],
                    [1278028800000, 246.94],
                    [1278288000000, 246.94],
                    [1278374400000, 248.63],
                    [1278460800000, 258.66],
                    [1278547200000, 258.09],
                    [1278633600000, 259.62],
                    [1278892800000, 257.28],
                    [1278979200000, 251.80],
                    [1279065600000, 252.73],
                    [1279152000000, 251.45],
                    [1279238400000, 249.90],
                    [1279497600000, 245.58],
                    [1279584000000, 251.89],
                    [1279670400000, 254.24],
                    [1279756800000, 259.02],
                    [1279843200000, 259.94],
                    [1280102400000, 259.28],
                    [1280188800000, 264.08],
                    [1280275200000, 260.96],
                    [1280361600000, 258.11],
                    [1280448000000, 257.25],

                    [1280707200000, 261.85],
                    [1280793600000, 261.93],
                    [1280880000000, 262.98],
                    [1280966400000, 261.70],
                    [1281052800000, 260.09],
                    [1281312000000, 261.75],
                    [1281398400000, 259.41],
                    [1281484800000, 250.19],
                    [1281571200000, 251.79],
                    [1281657600000, 249.10],
                    [1281916800000, 247.64],
                    [1282003200000, 251.97],
                    [1282089600000, 253.07],
                    [1282176000000, 249.88],
                    [1282262400000, 249.64],
                    [1282521600000, 245.80],
                    [1282608000000, 239.93],
                    [1282694400000, 242.89],
                    [1282780800000, 240.28],
                    [1282867200000, 241.62],
                    [1283126400000, 242.50],
                    [1283212800000, 243.10],

                    [1283299200000, 250.33],
                    [1283385600000, 252.17],
                    [1283472000000, 258.77],
                    [1283731200000, 258.77],
                    [1283817600000, 257.81],
                    [1283904000000, 262.92],
                    [1283990400000, 263.07],
                    [1284076800000, 263.41],
                    [1284336000000, 267.04],
                    [1284422400000, 268.06],
                    [1284508800000, 270.22],
                    [1284595200000, 276.57],
                    [1284681600000, 275.37],
                    [1284940800000, 283.23],
                    [1285027200000, 283.77],
                    [1285113600000, 287.75],
                    [1285200000000, 288.92],
                    [1285286400000, 292.32],
                    [1285545600000, 291.16],
                    [1285632000000, 286.86],
                    [1285718400000, 287.37],
                    [1285804800000, 283.75],

                    [1285891200000, 282.52],
                    [1286150400000, 278.64],
                    [1286236800000, 288.94],
                    [1286323200000, 289.19],
                    [1286409600000, 289.22],
                    [1286496000000, 294.07],
                    [1286755200000, 295.36],
                    [1286841600000, 298.54],
                    [1286928000000, 300.14],
                    [1287014400000, 302.31],
                    [1287100800000, 314.74],
                    [1287360000000, 318.00],
                    [1287446400000, 309.49],
                    [1287532800000, 310.53],
                    [1287619200000, 309.52],
                    [1287705600000, 307.47],
                    [1287964800000, 308.84],
                    [1288051200000, 308.05],
                    [1288137600000, 307.83],
                    [1288224000000, 305.24],
                    [1288310400000, 300.98],

                    [1288569600000, 304.18],
                    [1288656000000, 309.36],
                    [1288742400000, 312.80],
                    [1288828800000, 318.27],
                    [1288915200000, 317.13],
                    [1289174400000, 318.62],
                    [1289260800000, 316.08],
                    [1289347200000, 318.03],
                    [1289433600000, 316.66],
                    [1289520000000, 308.03],
                    [1289779200000, 307.04],
                    [1289865600000, 301.59],
                    [1289952000000, 300.50],
                    [1290038400000, 308.43],
                    [1290124800000, 306.73],
                    [1290384000000, 313.36],
                    [1290470400000, 308.73],
                    [1290556800000, 314.80],
                    [1290729600000, 315.00],
                    [1290988800000, 316.87],
                    [1291075200000, 311.15],

                    [1291161600000, 316.40],
                    [1291248000000, 318.15],
                    [1291334400000, 317.44],
                    [1291593600000, 320.15],
                    [1291680000000, 318.21],
                    [1291766400000, 321.01],
                    [1291852800000, 319.76],
                    [1291939200000, 320.56],
                    [1292198400000, 321.67],
                    [1292284800000, 320.29],
                    [1292371200000, 320.36],
                    [1292457600000, 321.25],
                    [1292544000000, 320.61],
                    [1292803200000, 322.21],
                    [1292889600000, 324.20],
                    [1292976000000, 325.16],
                    [1293062400000, 323.60],
                    [1293408000000, 324.68],
                    [1293494400000, 325.47],
                    [1293580800000, 325.29],
                    [1293667200000, 323.66],
                    [1293753600000, 322.56],

                    [1294012800000, 329.57],
                    [1294099200000, 331.29],
                    [1294185600000, 334.00],
                    [1294272000000, 333.73],
                    [1294358400000, 336.12],
                    [1294617600000, 342.46],
                    [1294704000000, 341.64],
                    [1294790400000, 344.42],
                    [1294876800000, 345.68],
                    [1294963200000, 348.48],
                    [1295308800000, 340.65],
                    [1295395200000, 338.84],
                    [1295481600000, 332.68],
                    [1295568000000, 326.72],
                    [1295827200000, 337.45],
                    [1295913600000, 341.40],
                    [1296000000000, 343.85],
                    [1296086400000, 343.21],
                    [1296172800000, 336.10],
                    [1296432000000, 339.32],

                    [1296518400000, 345.03],
                    [1296604800000, 344.32],
                    [1296691200000, 343.44],
                    [1296777600000, 346.50],
                    [1297036800000, 351.88],
                    [1297123200000, 355.20],
                    [1297209600000, 358.16],
                    [1297296000000, 354.54],
                    [1297382400000, 356.85],
                    [1297641600000, 359.18],
                    [1297728000000, 359.90],
                    [1297814400000, 363.13],
                    [1297900800000, 358.30],
                    [1297987200000, 350.56],
                    [1298332800000, 338.61],
                    [1298419200000, 342.62],
                    [1298505600000, 342.88],
                    [1298592000000, 348.16],
                    [1298851200000, 353.21],

                    [1298937600000, 349.31],
                    [1299024000000, 352.12],
                    [1299110400000, 359.56],
                    [1299196800000, 360.00],
                    [1299456000000, 355.36],
                    [1299542400000, 355.76],
                    [1299628800000, 352.47],
                    [1299715200000, 346.67],
                    [1299801600000, 351.99],
                    [1300060800000, 353.56],
                    [1300147200000, 345.43],
                    [1300233600000, 330.01],
                    [1300320000000, 334.64],
                    [1300406400000, 330.67],
                    [1300665600000, 339.30],
                    [1300752000000, 341.20],
                    [1300838400000, 339.19],
                    [1300924800000, 344.97],
                    [1301011200000, 351.54],
                    [1301270400000, 350.44],
                    [1301356800000, 350.96],
                    [1301443200000, 348.63],
                    [1301529600000, 348.51],

                    [1301616000000, 344.56],
                    [1301875200000, 341.19],
                    [1301961600000, 338.89],
                    [1302048000000, 338.04],
                    [1302134400000, 338.08],
                    [1302220800000, 335.06],
                    [1302480000000, 330.80],
                    [1302566400000, 332.40],
                    [1302652800000, 336.13],
                    [1302739200000, 332.42],
                    [1302825600000, 327.46],
                    [1303084800000, 331.85],
                    [1303171200000, 337.86],
                    [1303257600000, 342.41],
                    [1303344000000, 350.70],
                    [1303689600000, 353.01],
                    [1303776000000, 350.42],
                    [1303862400000, 350.15],
                    [1303948800000, 346.75],
                    [1304035200000, 350.13],

                    [1304294400000, 346.28],
                    [1304380800000, 348.20],
                    [1304467200000, 349.57],
                    [1304553600000, 346.75],
                    [1304640000000, 346.66],
                    [1304899200000, 347.60],
                    [1304985600000, 349.45],
                    [1305072000000, 347.23],
                    [1305158400000, 346.57],
                    [1305244800000, 340.50],
                    [1305504000000, 333.30],
                    [1305590400000, 336.14],
                    [1305676800000, 339.87],
                    [1305763200000, 340.53],
                    [1305849600000, 335.22],
                    [1306108800000, 334.40],
                    [1306195200000, 332.19],
                    [1306281600000, 336.78],
                    [1306368000000, 335.00],
                    [1306454400000, 337.41],
                    [1306800000000, 347.83],

                    [1306886400000, 345.51],
                    [1306972800000, 346.10],
                    [1307059200000, 343.44],
                    [1307318400000, 338.04],
                    [1307404800000, 332.04],
                    [1307491200000, 332.24],
                    [1307577600000, 331.49],
                    [1307664000000, 325.90],
                    [1307923200000, 326.60],
                    [1308009600000, 332.44],
                    [1308096000000, 326.75],
                    [1308182400000, 325.16],
                    [1308268800000, 320.26],
                    [1308528000000, 315.32],
                    [1308614400000, 325.30],
                    [1308700800000, 322.61],
                    [1308787200000, 331.23],
                    [1308873600000, 326.35],
                    [1309132800000, 332.04],
                    [1309219200000, 335.26],
                    [1309305600000, 334.04],
                    [1309392000000, 335.67],

                    [1309478400000, 343.26],
                    [1309824000000, 349.43],
                    [1309910400000, 351.76],
                    [1309996800000, 357.20],
                    [1310083200000, 359.71],
                    [1310342400000, 354.00],
                    [1310428800000, 353.75],
                    [1310515200000, 358.02],
                    [1310601600000, 357.77],
                    [1310688000000, 364.92],
                    [1310947200000, 373.80],
                    [1311033600000, 376.85],
                    [1311120000000, 386.90],
                    [1311206400000, 387.29],
                    [1311292800000, 393.30],
                    [1311552000000, 398.50],
                    [1311638400000, 403.41],
                    [1311724800000, 392.59],
                    [1311811200000, 391.82],
                    [1311897600000, 390.48],

                    [1312156800000, 396.75],
                    [1312243200000, 388.21],
                    [1312329600000, 392.57],
                    [1312416000000, 377.37],
                    [1312502400000, 373.62],
                    [1312761600000, 353.21],
                    [1312848000000, 374.01],
                    [1312934400000, 363.69],
                    [1313020800000, 373.70],
                    [1313107200000, 376.99],
                    [1313366400000, 383.41],
                    [1313452800000, 380.48],
                    [1313539200000, 380.44],
                    [1313625600000, 366.05],
                    [1313712000000, 356.03],
                    [1313971200000, 356.44],
                    [1314057600000, 373.60],
                    [1314144000000, 376.18],
                    [1314230400000, 373.72],
                    [1314316800000, 383.58],
                    [1314576000000, 389.97],
                    [1314662400000, 389.99],
                    [1314748800000, 384.83],

                    [1314835200000, 381.03],
                    [1314921600000, 374.05],
                    [1315267200000, 379.74],
                    [1315353600000, 383.93],
                    [1315440000000, 384.14],
                    [1315526400000, 377.48],
                    [1315785600000, 379.94],
                    [1315872000000, 384.62],
                    [1315958400000, 389.30],
                    [1316044800000, 392.96],
                    [1316131200000, 400.50],
                    [1316390400000, 411.63],
                    [1316476800000, 413.45],
                    [1316563200000, 412.14],
                    [1316649600000, 401.82],
                    [1316736000000, 404.30],
                    [1316995200000, 403.17],
                    [1317081600000, 399.26],
                    [1317168000000, 397.01],
                    [1317254400000, 390.57],
                    [1317340800000, 381.32],

                    [1317600000000, 374.60],
                    [1317686400000, 372.50],
                    [1317772800000, 378.25],
                    [1317859200000, 377.37],
                    [1317945600000, 369.80],
                    [1318204800000, 388.81],
                    [1318291200000, 400.29],
                    [1318377600000, 402.19],
                    [1318464000000, 408.43],
                    [1318550400000, 422.00],
                    [1318809600000, 419.99],
                    [1318896000000, 422.24],
                    [1318982400000, 398.62],
                    [1319068800000, 395.31],
                    [1319155200000, 392.87],
                    [1319414400000, 405.77],
                    [1319500800000, 397.77],
                    [1319587200000, 400.60],
                    [1319673600000, 404.69],
                    [1319760000000, 404.95],
                    [1320019200000, 404.78],

                    [1320105600000, 396.51],
                    [1320192000000, 397.41],
                    [1320278400000, 403.07],
                    [1320364800000, 400.24],
                    [1320624000000, 399.73],
                    [1320710400000, 406.23],
                    [1320796800000, 395.28],
                    [1320883200000, 385.22],
                    [1320969600000, 384.62],
                    [1321228800000, 379.26],
                    [1321315200000, 388.83],
                    [1321401600000, 384.77],
                    [1321488000000, 377.41],
                    [1321574400000, 374.94],
                    [1321833600000, 369.01],
                    [1321920000000, 376.51],
                    [1322006400000, 366.99],
                    [1322179200000, 363.57],
                    [1322438400000, 376.12],
                    [1322524800000, 373.20],
                    [1322611200000, 382.20],

                    [1322697600000, 387.93],
                    [1322784000000, 389.70],
                    [1323043200000, 393.01],
                    [1323129600000, 390.95],
                    [1323216000000, 389.09],
                    [1323302400000, 390.66],
                    [1323388800000, 393.62],
                    [1323648000000, 391.84],
                    [1323734400000, 388.81],
                    [1323820800000, 380.19],
                    [1323907200000, 378.94],
                    [1323993600000, 381.02],
                    [1324252800000, 382.21],
                    [1324339200000, 395.95],
                    [1324425600000, 396.44],
                    [1324512000000, 398.55],
                    [1324598400000, 403.33],
                    [1324944000000, 406.53],
                    [1325030400000, 402.64],
                    [1325116800000, 405.12],
                    [1325203200000, 405.00],

                    [1325548800000, 411.23],
                    [1325635200000, 413.44],
                    [1325721600000, 418.03],
                    [1325808000000, 422.40],
                    [1326067200000, 421.73],
                    [1326153600000, 423.24],
                    [1326240000000, 422.55],
                    [1326326400000, 421.39],
                    [1326412800000, 419.81],
                    [1326758400000, 424.70],
                    [1326844800000, 429.11],
                    [1326931200000, 427.75],
                    [1327017600000, 420.30],
                    [1327276800000, 427.41],
                    [1327363200000, 420.41],
                    [1327449600000, 446.66],
                    [1327536000000, 444.63],
                    [1327622400000, 447.28],
                    [1327881600000, 453.01],
                    [1327968000000, 456.48],

                    [1328054400000, 456.19],
                    [1328140800000, 455.12],
                    [1328227200000, 459.68],
                    [1328486400000, 463.97],
                    [1328572800000, 468.83],
                    [1328659200000, 476.68],
                    [1328745600000, 493.17],
                    [1328832000000, 493.42],
                    [1329091200000, 502.60],
                    [1329177600000, 509.46],
                    [1329264000000, 497.67],
                    [1329350400000, 502.21],
                    [1329436800000, 502.12],
                    [1329782400000, 514.85],
                    [1329868800000, 513.04],
                    [1329955200000, 516.39],
                    [1330041600000, 522.41],
                    [1330300800000, 525.76],
                    [1330387200000, 535.41],
                    [1330473600000, 542.44],

                    [1330560000000, 544.47],
                    [1330646400000, 545.18],
                    [1330905600000, 533.16],
                    [1330992000000, 530.26],
                    [1331078400000, 530.69],
                    [1331164800000, 541.99],
                    [1331251200000, 545.17],
                    [1331510400000, 552.00],
                    [1331596800000, 568.10],
                    [1331683200000, 589.58],
                    [1331769600000, 585.56],
                    [1331856000000, 585.57],
                    [1332115200000, 601.10],
                    [1332201600000, 605.96],
                    [1332288000000, 602.50],
                    [1332374400000, 599.34],
                    [1332460800000, 596.05],
                    [1332720000000, 606.98],
                    [1332806400000, 614.48],
                    [1332892800000, 617.62],
                    [1332979200000, 609.86],
                    [1333065600000, 599.55],

                    [1333324800000, 618.63],
                    [1333411200000, 629.32],
                    [1333497600000, 624.31],
                    [1333584000000, 633.68],
                    [1333929600000, 636.23],
                    [1334016000000, 628.44],
                    [1334102400000, 626.20],
                    [1334188800000, 622.77],
                    [1334275200000, 605.23],
                    [1334534400000, 580.13],
                    [1334620800000, 609.70],
                    [1334707200000, 608.34],
                    [1334793600000, 587.44],
                    [1334880000000, 572.98],
                    [1335139200000, 571.70],
                    [1335225600000, 560.28],
                    [1335312000000, 610.00],
                    [1335398400000, 607.70],
                    [1335484800000, 603.00],
                    [1335744000000, 583.98],

                    [1335830400000, 582.13],
                    [1335916800000, 585.98],
                    [1336003200000, 581.82],
                    [1336089600000, 565.25],
                    [1336348800000, 569.48],
                    [1336435200000, 568.18],
                    [1336521600000, 569.18],
                    [1336608000000, 570.52],
                    [1336694400000, 566.71],
                    [1336953600000, 558.22],
                    [1337040000000, 553.17],
                    [1337126400000, 546.08],
                    [1337212800000, 530.12],
                    [1337299200000, 530.38],
                    [1337558400000, 561.28],
                    [1337644800000, 556.97],
                    [1337731200000, 570.56],
                    [1337817600000, 565.32],
                    [1337904000000, 562.29],
                    [1338249600000, 572.27],
                    [1338336000000, 579.17],
                    [1338422400000, 577.73],

                    [1338508800000, 560.99],
                    [1338768000000, 564.29],
                    [1338854400000, 562.83],
                    [1338940800000, 571.46],
                    [1339027200000, 571.72],
                    [1339113600000, 580.32],
                    [1339372800000, 571.17],
                    [1339459200000, 576.16],
                    [1339545600000, 572.16],
                    [1339632000000, 571.53],
                    [1339718400000, 574.13],
                    [1339977600000, 585.78],
                    [1340064000000, 587.41],
                    [1340150400000, 585.74],
                    [1340236800000, 577.67],
                    [1340323200000, 582.10],
                    [1340582400000, 570.76],
                    [1340668800000, 572.02],
                    [1340755200000, 574.50],
                    [1340841600000, 569.05],
                    [1340928000000, 584.00],

                    [1341187200000, 592.52],
                    [1341273600000, 599.41],
                    [1341446400000, 609.94],
                    [1341532800000, 605.88],
                    [1341792000000, 613.89],
                    [1341878400000, 608.21],
                    [1341964800000, 604.43],
                    [1342051200000, 598.90],
                    [1342137600000, 604.97],
                    [1342396800000, 606.91],
                    [1342483200000, 606.94],
                    [1342569600000, 606.26],
                    [1342656000000, 614.32],
                    [1342742400000, 604.30],
                    [1343001600000, 603.83],
                    [1343088000000, 600.92],
                    [1343174400000, 574.97],
                    [1343260800000, 574.88],
                    [1343347200000, 585.16],
                    [1343606400000, 595.03],
                    [1343692800000, 610.76],

                    [1343779200000, 606.81],
                    [1343865600000, 607.79],
                    [1343952000000, 615.70],
                    [1344211200000, 622.55],
                    [1344297600000, 620.91],
                    [1344384000000, 619.86],
                    [1344470400000, 620.73],
                    [1344556800000, 621.70],
                    [1344816000000, 630.00],
                    [1344902400000, 631.69],
                    [1344988800000, 630.83],
                    [1345075200000, 636.34],
                    [1345161600000, 648.11],
                    [1345420800000, 665.15],
                    [1345507200000, 656.06],
                    [1345593600000, 668.87],
                    [1345680000000, 662.63],
                    [1345766400000, 663.22],
                    [1346025600000, 675.68],
                    [1346112000000, 674.80],
                    [1346198400000, 673.47],
                    [1346284800000, 663.87],
                    [1346371200000, 665.24],

                    [1346716800000, 674.97],
                    [1346803200000, 670.23],
                    [1346889600000, 676.27],
                    [1346976000000, 680.44],
                    [1347235200000, 662.74],
                    [1347321600000, 660.59],
                    [1347408000000, 669.79],
                    [1347494400000, 682.98],
                    [1347580800000, 691.28],
                    [1347840000000, 699.78],
                    [1347926400000, 701.91],
                    [1348012800000, 702.10],
                    [1348099200000, 698.70],
                    [1348185600000, 700.10],
                    [1348444800000, 690.79],
                    [1348531200000, 673.54],
                    [1348617600000, 665.18],
                    [1348704000000, 681.32],
                    [1348790400000, 667.10],

                    [1349049600000, 659.39],
                    [1349136000000, 661.31],
                    [1349222400000, 671.45],
                    [1349308800000, 666.80],
                    [1349395200000, 652.59],
                    [1349654400000, 638.17],
                    [1349740800000, 635.85],
                    [1349827200000, 640.91],
                    [1349913600000, 628.10],
                    [1350000000000, 629.71],
                    [1350259200000, 634.76],
                    [1350345600000, 649.79],
                    [1350432000000, 644.61],
                    [1350518400000, 632.64],
                    [1350604800000, 609.84],
                    [1350864000000, 634.03],
                    [1350950400000, 613.36],
                    [1351036800000, 616.83],
                    [1351123200000, 609.54],
                    [1351209600000, 604.00],
                    [1351641600000, 595.32],

                    [1351728000000, 596.54],
                    [1351814400000, 576.80],
                    [1352073600000, 584.62],
                    [1352160000000, 582.85],
                    [1352246400000, 558.00],
                    [1352332800000, 537.75],
                    [1352419200000, 547.06],
                    [1352678400000, 542.83],
                    [1352764800000, 542.90],
                    [1352851200000, 536.88],
                    [1352937600000, 525.62],
                    [1353024000000, 527.68],
                    [1353283200000, 565.73],
                    [1353369600000, 560.91],
                    [1353456000000, 561.70],
                    [1353628800000, 571.50],
                    [1353888000000, 589.53],
                    [1353974400000, 584.78],
                    [1354060800000, 582.94],
                    [1354147200000, 589.36],
                    [1354233600000, 585.28],

                    [1354492800000, 586.19],
                    [1354579200000, 575.85],
                    [1354665600000, 538.79],
                    [1354752000000, 547.24],
                    [1354838400000, 533.25],
                    [1355097600000, 529.82],
                    [1355184000000, 541.39],
                    [1355270400000, 539.00],
                    [1355356800000, 529.69],
                    [1355443200000, 509.79],
                    [1355702400000, 518.83],
                    [1355788800000, 533.90],
                    [1355875200000, 526.31],
                    [1355961600000, 521.73],
                    [1356048000000, 519.33],
                    [1356307200000, 520.17],
                    [1356480000000, 513.00],
                    [1356566400000, 515.06],
                    [1356652800000, 509.59],
                    [1356912000000, 532.17],

                    [1357084800000, 549.03],
                    [1357171200000, 542.10],
                    [1357257600000, 527.00],
                    [1357516800000, 523.90],
                    [1357603200000, 525.31],
                    [1357689600000, 517.10],
                    [1357776000000, 523.51],
                    [1357862400000, 520.30],
                    [1358121600000, 501.75],
                    [1358208000000, 485.92],
                    [1358294400000, 506.09],
                    [1358380800000, 502.68],
                    [1358467200000, 500.00],
                    [1358812800000, 504.77],
                    [1358899200000, 514.00],
                    [1358985600000, 450.50],
                    [1359072000000, 439.88],
                    [1359331200000, 449.83],
                    [1359417600000, 458.27],
                    [1359504000000, 456.83],
                    [1359590400000, 455.49],

                    [1359676800000, 453.62],
                    [1359936000000, 442.32],
                    [1360022400000, 457.84],
                    [1360108800000, 457.35],
                    [1360195200000, 468.22],
                    [1360281600000, 474.98],
                    [1360540800000, 479.93],
                    [1360627200000, 467.90],
                    [1360713600000, 467.01],
                    [1360800000000, 466.59],
                    [1360886400000, 460.16],
                    [1361232000000, 459.99],
                    [1361318400000, 448.85],
                    [1361404800000, 446.06],
                    [1361491200000, 450.81],
                    [1361750400000, 442.80],
                    [1361836800000, 448.97],
                    [1361923200000, 444.57],
                    [1362009600000, 441.40],

                    [1362096000000, 430.47],
                    [1362355200000, 420.05],
                    [1362441600000, 431.14],
                    [1362528000000, 425.66],
                    [1362614400000, 430.58],
                    [1362700800000, 431.72],
                    [1362960000000, 437.87],
                    [1363046400000, 428.43],
                    [1363132800000, 428.35],
                    [1363219200000, 432.50],
                    [1363305600000, 443.66],
                    [1363564800000, 455.72],
                    [1363651200000, 454.49],
                    [1363737600000, 452.08],
                    [1363824000000, 452.73],
                    [1363910400000, 461.91],
                    [1364169600000, 463.58],
                    [1364256000000, 461.14],
                    [1364342400000, 452.08],
                    [1364428800000, 442.66],

                    [1364774400000, 428.91],
                    [1364860800000, 429.79],
                    [1364947200000, 431.99],
                    [1365033600000, 427.72],
                    [1365120000000, 423.20],
                    [1365379200000, 426.21],
                    [1365465600000, 426.98],
                    [1365552000000, 435.69],
                    [1365638400000, 434.33],
                    [1365724800000, 429.80],
                    [1365984000000, 419.85],
                    [1366070400000, 426.24],
                    [1366156800000, 402.80],
                    [1366243200000, 392.05],
                    [1366329600000, 390.53],
                    [1366588800000, 398.67],
                    [1366675200000, 406.13],
                    [1366761600000, 405.46],
                    [1366848000000, 408.38],
                    [1366934400000, 417.20],
                    [1367193600000, 430.12],
                    [1367280000000, 442.78],

                    [1367366400000, 439.29],
                    [1367452800000, 445.52],
                    [1367539200000, 449.98],
                    [1367798400000, 460.71],
                    [1367884800000, 458.66],
                    [1367971200000, 463.84],
                    [1368057600000, 456.77],
                    [1368144000000, 452.97]
                ];
            var chart = Highcharts.stockChart('chart-portfolio', {
                title: {
                    text: 'My Portfolio Chart'
                },

                rangeSelector: {
                    selected: 1
                },

                series: [{
                    name: 'My Portfolio Chart',
                    data: data,
                    type: 'area',
                    threshold: null,
                    tooltip: {
                        valueDecimals: 2
                    }
                }],
                responsive: {
                    rules: [{
                        condition: {
                            maxWidth: 500
                        },
                        chartOptions: {
                            chart: {
                                height: 300
                            },
                            subtitle: {
                                text: null
                            },
                            navigator: {
                                enabled: false
                            }
                        }
                    }]
                },
                credits: {
                    enabled: false
                },
                navigator: {
                    enabled: false
                }
            });
        }
        function drawPieChart() {
            Highcharts.chart('pie-chart', {
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: 'Coins Held'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Coin',
                    colorByPoint: true,
                    data: [{
                        name: 'BTC',
                        y: 61.41,
                        sliced: true,
                        selected: true
                    }, {
                        name: 'ETH',
                        y: 11.84
                    }, {
                        name: 'XRP',
                        y: 10.85
                    }, {
                        name: 'XLM',
                        y: 4.67
                    }, {
                        name: 'TRX',
                        y: 4.18
                    }, {
                        name: 'CVC',
                        y: 7.05
                    }]
                }],
                credits: {
                    enabled: false
                }
            });
        }
        drawPortfolioChart();
        drawPieChart();
        
    </script>
</asp:Content>