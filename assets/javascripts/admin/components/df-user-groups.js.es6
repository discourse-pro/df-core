import Group from 'discourse/models/group';
/**
 * Inspired by app/assets/javascripts/admin/components/admin-group-selector.js.es6
 * (which is not convenient for me because it does not allow to remove system groups
 * once they have added).
 */
export default Ember.Component.extend({
	tagName: 'div'
	/**
	 * 2015-06-29
	 * Discourse expects the components's template at
	 * plugins/df-core/assets/javascripts/discourse/templates/components/df-user-groups.hbs
	 * Until I know it I used to specify template location explicitly:
	 * @link http://stackoverflow.com/a/24271614
	 * ,layoutName: 'javascripts/admin/templates/components/df-user-groups'
	 * Now I save the explicit method for history only. May be it will be useful sometimes.
	 */
	,_init: function() {
		const _this = this;
		Group.findAll().then(function(availableUserGroups) {
			_this.set('allGroups', availableUserGroups);
			_this.$('input').select2({
				multiple: true
				,width: '100%'
				, query: function(opts) {
					opts.callback({results: this.get('allGroups').map(this._format)});
				}.bind(_this)
			}).on('change', function(evt) {
				if (evt.added || evt.removed) {
					_this.triggerAction({action:'groupChanged', actionContext: {
						item: _this.get('item')
						, groupId: evt.added ? evt.added.id : evt.removed.id
						, isAdded: !!evt.added
						/**
						 * 2015-06-30
						 * Чтобы можно было различать несколько компонентов.
						 * Например:
						 * @see plugins/df-paid-membership/assets/javascripts/admin/templates/components/paid-membership-plans.hbs
						 * {{df-user-groups type='allowed' item=item selected=item.allowedGroupIds}}
						 * {{df-user-groups  type='granted' item=item selected=item.grantedGroupIds}}
						 */
						, type: _this.get('type')
					}});
				}
			}.bind(_this));
			_this._refreshOnReset();
		});
	}.on('didInsertElement')
	/**
	 * 2015-06-29
	 * Одной из основных причин использования нашего компонента
	 * вместо компонента ядра app/assets/javascripts/admin/components/admin-group-selector.js.es6
	 * является то, что в компоненте ядра здесь код:
	 * 'locked': item.automatic
	 * который не позволет убирать ранее выбранные системные группы.
	 */
	,_format(item) {return {'text': item.name, 'id': item.id, 'locked': false};}
	,_refreshOnReset: function() {
		var selectedIds = this.get('selected') || [];
		var allGroups = this.get('allGroups');
		var selectedGroups = [];
		selectedIds.forEach(function(id) {
			var group = allGroups.findBy('id', id);
			if (group) {
				selectedGroups.push(group);
			}
		});
		this.$('input').select2('data', selectedGroups.map(this._format));
	}.observes('selected')
});