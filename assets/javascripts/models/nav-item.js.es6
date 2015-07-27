/**
 * @see app/assets/javascripts/discourse/models/nav_item.js
 * @link https://github.com/discourse/discourse/blob/v1.4.0.beta6/app/assets/javascripts/discourse/models/nav_item.js#L10
 */
export default Discourse.NavItem.extend({
	filterMode: function() {return this.get('name');}.property('name')
	,href: function() {return this.get('href');}.property('href')
});