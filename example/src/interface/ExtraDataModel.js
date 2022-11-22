export default class ExtraDataModel {
    addNewMember = false
    memberPayService = ''
    memberPayMemberId = ''
    memberId = ''

    constructor(addNewMember, memberPayService, memberPayMemberId, memberId) {
        this.addNewMember = addNewMember;
        this.memberPayService = memberPayService;
        this.memberPayMemberId = memberPayMemberId;
        this.memberId = memberId;
    }

     fromJson(new_json) {
        var addNewMember = false;
        var memberPayService = '';
        var memberPayMemberId = '';
        var memberId = '';

        var json = JSON.parse(new_json);
        if(json['addNewMember'] != null) {
            addNewMember = json['addNewMember'] ;
        }
        if(json['memberPayService'] != null) {
            memberPayService = json['memberPayService'] ;
        }
        if(json['memberPayMemberId'] != null) {
            memberPayMemberId = json['memberPayMemberId'] ;
        }
        if(json['memberId'] != null) {
            memberId = json['memberId'] ;
        }
        return new ExtraDataModel(addNewMember, memberPayService, memberPayMemberId, memberId);
    }

     toJson() {
        return JSON.stringify(this);
    }
}