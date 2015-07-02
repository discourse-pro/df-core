import SiteSetting from 'admin/components/site-setting';
export default {name: 'df-core-admin', after: 'inject-objects', initialize: function() {
	const myTypes = ['df_editor', 'paid_membership_plans', 'paypal_buttons'];
	SiteSetting.reopen({
		partialType: function() {
			var type = this.get('setting.type');
			return -1 < myTypes.indexOf(type) ? type : this._super();
		}.property('setting.type')
	});
}};
