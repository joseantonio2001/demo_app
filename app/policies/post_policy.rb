class PostPolicy < ApplicationPolicy
    def index?
        true
    end

    def show?
        true
    end

    def create?
        user.present?
    end

    def new?
        create?
    end

    def update?
        user.present? && user == record.user
    end

    def edit?
        update?
    end

    def destroy?
        user.present? && user == record.user
    end
end