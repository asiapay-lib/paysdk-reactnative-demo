export default class CardDetailModel {
    cardNo = ''
    month = ''
    year = ''
    cardHolder = ''
    cvc = ''

    constructor(cardNo, month, year, cardHolder, cvc) {
        this.cardNo = cardNo;
        this.month = month;
        this.year = year;
        this.cardHolder = cardHolder;
        this.cvc = cvc;
    }

    fromJson(new_json) {
        var cardNo = ''
        var month = ''
        var year = ''
        var cardHolder = ''
        var cvc = ''

        var json = JSON.parse(new_json);
        if (json['cardNo'] != null) {
            cardNo = json['cardNo'] ;
        }
        if (json['month'] != null) {
            month = json['month'] ;
        }
        if (json['year'] != null) {
            year = json['year'] ;
        }
        if (json['cardHolder'] != null) {
            cardHolder = json['cardHolder'] ;
        }
        if (json['cvc'] != null) {
            cvc = json['cvc'] ;
        }
        return new CardDetailModel(cardNo, month, year, cardHolder, cvc);
    }

    toJson() {
        return JSON.stringify(this);
    }
}